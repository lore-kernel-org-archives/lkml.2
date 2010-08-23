Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab0HWRSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:18:21 -0400
Received: from chiark.greenend.org.uk ([212.13.197.229]:48701 "EHLO
	chiark.greenend.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab0HWRSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:18:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19570.44367.719276.128881@chiark.greenend.org.uk>
Date: Mon, 23 Aug 2010 18:18:07 +0100
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] mlock/stack guard interaction fixup
In-Reply-To: <1282580751.2605.1997.camel@laptop>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	<1282391770.29609.1223.camel@localhost.localdomain>
	<AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	<1282460275.11348.865.camel@localhost.localdomain>
	<1282462386.11348.871.camel@localhost.localdomain>
	<1282470917.11348.891.camel@localhost.localdomain>
	<20100822172548.GB8957@suse.de>
	<AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
	<19570.38608.79434.179797@chiark.greenend.org.uk>
	<1282580751.2605.1997.camel@laptop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
From: Ian Jackson <ijackson@chiark.greenend.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes ("Re: [RFC] mlock/stack guard interaction fixup"):
> On Mon, 2010-08-23 at 16:42 +0100, ijackson@chiark.greenend.org.uk
> wrote:
> > mlocking the stack is entirely sensible and normal for a real-time
> > program.  Most such programs use mlockall but there is no particular
> > reason why a program that has some more specific requirements should
> > use mlock to lock only a part of the stack.  (Perhaps it has only one
> > real-time thread?) 
> 
> RT apps should pre-allocate and mlock their stack in advance (and
> pre-fault too for the paranoid).

Are you allowed to mlock a stack page which has not yet been faulted
in ?  What effect does it have ?  I wasn't able to find a convincing
de jure answer to this question.

But you seem, like me, to be disagreeing with Linus's assertion that
calling mlock() on the stack is something no sane programs does ?

> mlockall is a very bad interface and should really not be used.

You are directly contradicting the advice in SuS, to which I just gave
a reference.  You're free to do so of course but it might be worth
explaining in a bit more detail why the advice in SuS is wrong.

Ian.
