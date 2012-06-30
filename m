Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2F3Mss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 08:48:48 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45210 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab2F3Msq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 08:48:46 -0400
Date: Sat, 30 Jun 2012 13:52:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Vincent Sanders <vincent.sanders@collabora.co.uk>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
Message-ID: <20120630135240.41dbaacf@pyramind.ukuu.org.uk>
In-Reply-To: <20120630001350.GS21968@kvack.org>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
	<20120629.153656.1141845894730637434.davem@davemloft.net>
	<20120629231236.GA28593@mail.collabora.co.uk>
	<20120629.161821.948325645333976311.davem@davemloft.net>
	<20120629234230.GA11480@kyllikki.org>
	<20120630001350.GS21968@kvack.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012 20:13:50 -0400
Benjamin LaHaise <bcrl@kvack.org> wrote:

> On Sat, Jun 30, 2012 at 12:42:30AM +0100, Vincent Sanders wrote:
> > The current users are suffering from the issues outlined in my
> > introductory mail all the time. These issues are caused by emulating an
> > IPC system over AF_UNIX in userspace.
> 
> Nothing in your introductory statements indicate how your requirements 
> can't be met through a hybrid socket + shared memory solution.  The IPC 
> facilities of the kernel are already quite rich, and sufficient for 
> building many kinds of complex systems.  What's so different about DBus' 
> requirements?

dbus wants to
- multicast
- pass file handles
- never lose an event
- be fast
- have a security model

The security model makes a shared memory hack impractical, the file
handle passing means at least some of it needs to be AF_UNIX. The event
loss handling/speed argue for putting it in kernel.

I'm not convinced AF_BUS entirely sorts this either. In particular the
failure case dbus currently has to handle for not losing events allows it
to identify who in a "group" has jammed the bus by not listening (eg by
locking up). This information appears to be lost in the AF_BUS case and
that's slightly catastrophic for error recovery.

Alan
