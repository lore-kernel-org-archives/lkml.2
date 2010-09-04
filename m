Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0IDOXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 10:23:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39398 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752781Ab0IDOW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 10:22:59 -0400
Date: Sat, 4 Sep 2010 15:41:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Calvin Walton <calvin.walton@gmail.com>
Cc: Florian Weimer <fweimer@bfk.de>, miaox@cn.fujitsu.com,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/3] lib: improve the performance of memcpy and memmove
 of the general version
Message-ID: <20100904154114.19501d6e@lxorguk.ukuu.org.uk>
In-Reply-To: <1283605142.9039.4.camel@ayu>
References: <4C7E2CAC.6080102@cn.fujitsu.com>
	<82mxrzrsvq.fsf@mid.bfk.de>
	<1283605142.9039.4.camel@ayu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Sep 2010 08:59:02 -0400
Calvin Walton <calvin.walton@gmail.com> wrote:

> On Fri, 2010-09-03 at 11:03 +0000, Florian Weimer wrote:
> > * Miao Xie:
> > 
> > >  EXPORT_SYMBOL(memcpy);
> > 
> > I think you need to change that to EXPORT_SYMBOL_GPL, because the code
> > is now licensed under the GPL, and not the GPL plus kernel exceptions
> > (whatever they are, but they undoubtly exist), unlike the original
> > implementation.
> 
> I wouldn't think so - the intent of EXPORT_SYMBOL_GPL is to mark symbols
> that make it obvious that a module was derived from the Linux kernel, as
> opposed to some sort of generic driver that was just ported to a new
> interface. (It's not foolproof, it's more of a warning to developers.)

EXPORT_SYMBOL_GPL was meant for symbols that were clearly internal
workings. EXPORT_SYMBOL() doesn't in any way imply or excuse GPL
compliance for any derivative work.

Using the FSF memcpy seems a good technical idea, and it'll no doubt
liven up the proprietary module makers lawyers as it'll make the FSF a
party to any infringement disputes 8)

Alan
