Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab0JGRmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:42:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39915 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751412Ab0JGRmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:42:12 -0400
Date: Thu, 7 Oct 2010 19:07:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        agruen@suse.de
Subject: Re: Linux 2.6.36-rc7
Message-ID: <20101007190741.2dc62626@lxorguk.ukuu.org.uk>
In-Reply-To: <1286472835.2656.15.camel@dhcp231-98.rdu.redhat.com>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	<201010071710.46938.tvrtko.ursulin@sophos.com>
	<201010071815.54303.tvrtko.ursulin@sophos.com>
	<1286472835.2656.15.camel@dhcp231-98.rdu.redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I see two possibilities off the top of my head:
> 
> I could just slap an (unused) priority field onto the end of the
> fanotify_init() syscall (assuming Linus doesn't murder me) so we can
> build that support out with explicit priorities down the line, which I
> think might be overkill, or
> 
> The other option (without breaking ABI as it stands today) is to define
> some set of the fanotify_init() flags to be a priority field, we've got
> 32 bits and only use 2 of them so giving 4-8 bits of that as a priority
> (next cycle) isn't an issue and can be easily backwards compatible.

Except you've then got a magic release that works differently to every
other release afterwards and which sods law says will get shipped by some
big vendor. Both your proposals are "we got the API wrong, lets have one
kernel that is special", that isn't good in the bigger scheme of things
and will have if kernel 2.6.blah then crap forced into bits of app/lib
code forever.

Given two chunks of "oh dear" last minute stuff would it be safer to
simply punt and just pull the syscall/prototype itself (leaving the rest)
for the release. That can go into the first pass of the next kernel tree,
and if it the fixes and priority bits all work out may well then be tiny
enough for -stable.

Alan
