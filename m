Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2EANfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:35:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55348 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab2EANfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:35:23 -0400
Date: Tue, 1 May 2012 14:34:29 +0100
From: Will Deacon <will.deacon@arm.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
Message-ID: <20120501133429.GB23919@mudshark.cambridge.arm.com>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
 <4F9ADD22.70003@zytor.com>
 <201204272052.34489.arnd@arndb.de>
 <201204271926.14872.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204271926.14872.vapier@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 12:26:11AM +0100, Mike Frysinger wrote:
> On Friday 27 April 2012 16:52:34 Arnd Bergmann wrote:
> > The main reasons I can see for not making it a general purpose API are:
> > 
> > * It's a very confusing interface, because the endianess rules are
> > different from the non-string variants and counterintuitive.
> > 
> > * Almost all the users are ancient ARM specific drivers, the others are
> >   either new ARM specific drivers or drivers that started out as ARM-only
> >   and were ported later to other architectures (sh, avr32, mips, mn10300
> >   and blackfin)
> > 
> > * On all these architectures, the PCI I/O space is memory mapped (or
> >   non-existent), so the ioread* functions are trivial wrappers without
> >   additional overhead.
> > 
> > * Most architectures don't implement them today, but all architectures
> >   that support MMIO also implement the ioread string operations.
> 
> i'm ambivalent with keeping or tossing these funcs.  Blackfin (afaik) picked 
> them up really only for the reasons Arnd cited -- drivers using memory mapped 
> registers originally for ARM (or m68k/coldfire i think) used this API, and it 
> was easier for us to implement these defines in our asm/io.h and get the 
> drivers "for free".

Makes sense and there's no compelling reason to convert drivers if they're
not being used by architectures without these functions.

> i am strongly in favor though of agreeing on & documenting the baseline API 
> first before attempting to clean anything up.  sorry to keep harping on this.

It would be nice if we could just use asm-generic/io.h as the documention,
i.e. if you want to write a portable driver, just stick to the functions
implemented there. Apart from the string accessors, I think it's already
fairly accurate. The __raw_* functions seem to be missing on s390 but I
don't think driver portability is a huge concern for that architecture.

Will
