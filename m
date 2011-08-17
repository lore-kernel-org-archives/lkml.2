Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1HQRYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:24:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35759 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753624Ab1HQRYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:24:46 -0400
Date: Wed, 17 Aug 2011 16:53:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, lennart@poettering.net,
        linux-man@vger.kernel.org, roland@hack.frob.com,
        torvalds@linux-foundation.org
Subject: Re: +
 prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision .patch
 added to -mm tree
Message-ID: <20110817165350.4bd3a2a9@lxorguk.ukuu.org.uk>
In-Reply-To: <CAPXgP101N_GESzpqu=P_H8cLoekMzb2_W2eWyAqATSjm4Gj9CA@mail.gmail.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
	<20110817115543.GA8745@redhat.com>
	<CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
	<20110817134516.GA14136@redhat.com>
	<CAPXgP101N_GESzpqu=P_H8cLoekMzb2_W2eWyAqATSjm4Gj9CA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> This is not meant as a security feature, if that's what your asking.
> It will not prevent services from doing nasty things and escape the
> process that started them. But it's still a feature that today only
> PID 1 and which we need for more processes.

I'm more worried about it beign a security flaw...

> > IOW, imho this doesn't look very useful "in general" to me.
> 
> It is very useful if you have an init-like daemon.

Which is a special case

> 
> > May be we need something else instead... And iiuc you don't really
> > need to change the reparenting, you only want the notification if
> > the process exits.
> 
> No, we want to be the parent of the process, and we want to be the one
> who reaps all the child process, not only receive some out-of-band
> notifications. The sub-init is the babysitter of all the things it has
> started, and that should be reflected in the parent child relation.

Why ?

