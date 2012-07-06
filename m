Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab2GFBSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 21:18:46 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:42898 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2GFBSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 21:18:43 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2012 21:18:43 EDT
Date: Fri, 6 Jul 2012 03:12:36 +0200
Message-Id: <201207060112.q661CaG4002389@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: geert@linux-m68k.org
CC: jack@suse.cz, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cris-kernel@axis.com
In-reply-to: <CAMuHMdVJTUF3r=MKzpkvj6y_xdVdw=zEgAy2_wm_hG94jdrhBA@mail.gmail.com>
	(message from Geert Uytterhoeven on Wed, 4 Jul 2012 22:17:28 +0200)
Subject: Re: size_t/ssize_t warnings (was: Re: Build regressions/improvements in
	v3.5-rc5)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Wed, 4 Jul 2012 22:17:28 +0200

> On Wed, Jul 4, 2012 at 3:34 PM, Jan Kara <jack@suse.cz> wrote:
> >>   + fs/quota/quota_tree.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 372:4
> >>   + fs/quota/quota_v2.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 66:92
> >   These really look like false positives (there are quite a few of this
> > kind). Can we possibly silence them?
> 
> These 2 warnings happen on cris only, because size_t is unsigned int and
> ssize_t is (signed) long.

Um, no, ssize_t isn't long.  Do you mean __kernel_ssize_t?
(Or are you looking at cris-axis-elf?  ...no, that can't be it,
as you see __SIZE_TYPE__ being unsigned int.)

> They go away if I make ssize_t int.

But ssize_t already is int...

N.B. size_t is different between cris-axis-elf and
cris-axis-linux-gnu.  The former uses the default definition in
gcc/defaults.h (long unsigned int) and the latter sets it
specifically to "unsigned int", in gcc/config/cris/linux.h (or
before 2010-12-09, from config/svr4.h).  The ssize_t definition
comes from glibc, where it is "int".

>                         __kernel_size_t                         __kernel_ssize_t
>                         ---------------                         ----------------

> cris:                   __SIZE_TYPE__ (unsigned int)            long

A bit odd; __kernel_ssize_t should probably change to int, to
match ssize_t.

> Cris-people: __SIZE_TYPE__ turned out to be hardcoded in my compiler (gcc
> 4.6.3 from Tony's collection) to unsigned int. Is that correct?

Correct, for cris-axis-linux-gnu.

> And why do some 32-bit architectures use unsigned long/long?

I'd guess from the gcc default.

brgds, H-P
