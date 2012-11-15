Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767817Ab2KONjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:39:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60765 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab2KONjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:39:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <rob.clark@linaro.org>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Date: Thu, 15 Nov 2012 13:39:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org> <201211150919.37343.arnd@arndb.de> <CAF6AEGv-O_D6nOnEwi5w8NUcv+dQFe7pJBXhUA8xq+tykG4dfg@mail.gmail.com>
In-Reply-To: <CAF6AEGv-O_D6nOnEwi5w8NUcv+dQFe7pJBXhUA8xq+tykG4dfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211151339.08016.arnd@arndb.de>
X-Provags-ID: V02:K0:grPB0L5kKqwZjdiuZ7q3sf0EnU1jqnelbrIA/s0/eOn
 HBjbjDfrbwRf4v7jOn1jQ7bpe2hzxx2PT7bSr5Wonqz+o3eYOM
 xaRCNm0vmPAMTNF9xOKUjN03xd9PxGI59h1Ns11qjN8Rci2NGW
 uwIPsCIL7n0092/KW88tcZwORRpY+4bhlDDRE2Cw1QsdKDCFMb
 FeOTG7G+Vc08D5uTH6sp4uCqT6YsrBtRX7Rm0i3YmUwWVXBvTD
 S1mFfYDUkRspqxXafqFyDQuGfmxX+TqbPxSHWZvl1260vS/NVe
 V3ZjGhEF6Q1l6V7scptxvwqgdFEWpcfNgruAIt6v5hlXfXX9dM
 PiZSNdrIQg4ON2eA7IyE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Rob Clark wrote:
> On Thu, Nov 15, 2012 at 3:19 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 13 November 2012, Russell King - ARM Linux wrote:
> >> You're missing something; that is one of the greatest powers of open
> >> source.  The many eyes (and minds) effect.  Someone out there probably
> >> has a solution to whatever problem, the trick is to find that person. :)
> >>
> >> I think we have a working solution for this for ARM.  It won't be suitable
> >> for every arch, where they have 8-bit and 16-bit registers able to be
> >> allocated by the compiler, but for architectures where the minimum register
> >> size is 32-bit, what we have below should work.
> >
> > I don't mind at all adding the extension to ARM, and I think it's pretty
> > cool that you guys actually found a working solution.
> >
> > The part that worries me is that we are making architecture independent
> > code depend on a clever hack that may or may not be possible to implement
> > on a given architecture, and that most architecture maintainers wouldn't
> > know how to implement correctly even if it's possible.
> 
> I could always send a 3rd version with a comment smashed on about why
> that works if you think this is a problem..

Comments are always good, so I'd surely like to see those get added.
As I said, I don't have any objections to the addition of your patch to
the ARM code, which sounds useful to have.

I still haven't heard a conclusive argument why we need to use get_user()
rather than copy_from_user() in the DRM code. Is this about a fast path
where you want to shave off a few cycles for each call, or does this
simplify the code structure, or something else?

	Arnd
