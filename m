Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0KOKEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:04:42 -0500
Received: from sunsite.ms.mff.cuni.cz ([195.113.15.26]:41572 "EHLO
	sunsite.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0KOKEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:04:42 -0500
Date: Mon, 15 Nov 2010 11:03:32 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Michael Matz <matz@suse.de>, Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org,
        Jim Bos <jim876@xs4all.nl>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com> <877hgorrj1.fsf@basil.nowhere.org> <4CD843DC.10106@gmail.com> <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de> <20101109134816.GB29433@basil.fritz.box> <m3lj52txaq.fsf@redhat.com> <4CD97A3D.1040602@xs4all.nl> <m31v6nmmr3.fsf@jhcloos.com> <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com> <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 09:56:05AM +0100, Jakub Jelinek wrote:
> On Sun, Nov 14, 2010 at 07:21:50PM -0800, Linus Torvalds wrote:
> > So when Richard Gunther says "a memory clobber doesn't cover automatic
> > storage", to me that very clearly spells "gcc is buggy as hell".
> > Because automatic storage with its address taken _very_ much gets
> > clobbered by things like memset etc. If the compiler doesn't
> > understand that, the compiler is just broken.
> 
> I'll leave the discussion about meaning of "memory" clobber aside to
> Richard,

And for this the starting point should be what has been requested,
i.e. preprocessed source + gcc options + gcc version and some hints what
actually misbehaves (with the , "+m" (*regs) change reverted)
in gcc bugzilla.  Only with that we can actually look at what has been
happening, see whether it is the tree optimizations or RTL and which one
makes a difference.
If I've missed a PR about this I apologize. 

	Jakub
