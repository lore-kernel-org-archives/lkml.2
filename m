Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1D0JbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:31:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56182 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754050Ab1D0JbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:31:08 -0400
Date: Wed, 27 Apr 2011 10:29:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 090/173] USB: serial/kobil_sct, fix potential tty NULL
 dereference
Message-ID: <20110427102903.62b2ae09@lxorguk.ukuu.org.uk>
In-Reply-To: <4DB740A3.4090702@suse.cz>
References: <20110425200236.905912775@pcw.home.local>
	<4DB6994B.3060204@suse.cz>
	<20110426195342.GB19594@1wt.eu>
	<4DB740A3.4090702@suse.cz>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Ok, but this doesn't fix the bug (the URB should be killed or something
> >> similar in that kernel), it only makes the window smaller.
> >
> > OK I get it now, it requires patch 4a90f09b which is quite not some
> > suitable material for -longterm.
> 
> Yeah and perhaps some other changes (like adding hangup support).
> 
> > Do you think it's better to completely remove this patch than making
> > one think the risk of bug is gone while it is not ? Unless we find
> > something more reliable, I'd rather drop the patch.
> 
> To be honest I don't know what's better :). Maybe I would incline to the 
> drop-it side, but leaving up to you.

I'm not sure why a .27 is still maintained to be honest but the reality
is that the lack of tty refcounting on hangup in old kernels is
exploitable in many cases via vhangup() and other approaches combined
with lack of NULL page protection. In several places NULL tty means
NULL->method() is invoked which on an old kernel where a user process has
mapped user virtual address zero means you just got owned.

This is all well known stuff. SELinux will mitigate fairly effectively on
some vendors systems.

Alan
