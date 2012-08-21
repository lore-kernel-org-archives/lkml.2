Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab2HUK20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:28:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49155 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab2HUK2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:28:13 -0400
Date: Tue, 21 Aug 2012 12:28:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 21/31] arm64: 32-bit (compat) applications support
Message-ID: <20120821102811.GA22126@elf.ucw.cz>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-22-git-send-email-catalin.marinas@arm.com>
 <20120820105308.GA906@elf.ucw.cz>
 <201208202034.55135.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208202034.55135.arnd@arndb.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2012-08-20 20:34:54, Arnd Bergmann wrote:
> On Monday 20 August 2012, Pavel Machek wrote:
> > > This patch adds support for 32-bit applications. The vectors page is a
> > > binary blob mapped into the application user space at 0xffff0000 (the
> > > AArch64 toolchain does not support compilation of AArch32 code). Full
> > > compatibility with ARMv7 user space is supported. The use of deprecated
> > > ARMv7 functionality (SWP, CP15 barriers) has been disabled by default on
> > > AArch64 kernels and unaligned LDM/STM is not supported.
> > > 
> > > Please note that only the ARM 32-bit EABI is supported, so no OABI
> > > compatibility.
> > 
> > > +struct compat_statfs {
> > > +     int             f_type;
> > > +     int             f_bsize;
> > > +     int             f_blocks;
> > > +     int             f_bfree;
> > > +     int             f_bavail;
> > > +     int             f_files;
> > > +     int             f_ffree;
> > > +     compat_fsid_t   f_fsid;
> > > +     int             f_namelen;      /* SunOS ignores this field. */
> > 
> > I'm sure it does. But is it good comment?
> 
> Good catch. It seems that some of the other compat platforms (x86,
> sparc, powerpc) have the same thing. I guess the real solution would
> be to introduce an asm-generic/compat.h file that contains a bunch
> of those definitions, like
> 
> #ifndef compat_timespec
> struct compat_timespec {
>         compat_time_t   tv_sec;
>         s32             tv_nsec;
> };
> #endif
> 
> #ifndef compat_timeval
> struct compat_timeval {
>         compat_time_t   tv_sec;
>         s32             tv_usec;
> };
> #endif

Yes, I guess that would be very good.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
