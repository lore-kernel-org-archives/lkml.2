Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab2GQWTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:19:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54160 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739Ab2GQWTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:19:17 -0400
Date: Tue, 17 Jul 2012 23:18:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120717221839.GA4856@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de>
 <20120710071023.GA10456@gmail.com>
 <20120710101018.GE15120@arm.com>
 <yw1x8vekd309.fsf@unicorn.mansr.com>
 <CA+55aFxL6uEre-c=JrhPfts=7BGmhb2Js1c2ZGkTH8F=+rEWDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxL6uEre-c=JrhPfts=7BGmhb2Js1c2ZGkTH8F=+rEWDg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 12:53:21AM +0100, Linus Torvalds wrote:
> On Sun, Jul 15, 2012 at 4:21 PM, Måns Rullgård <mans@mansr.com> wrote:
> >
> > FWIW, I'd prefer naming the directory either arm64 or armv8 for a few
> > reasons:
> >
> > - Those are the names people actually use to refer to the architecture
> > - They are more descriptive.
> > - I think the official name is rather silly.
> 
> Agreed on those three for arm64.
> 
> However, please don't use the *INSANE* ARM "v8" naming.

I agree, ARMv8 is not the right name to use in this situation. It doesn't
qualify whether the system is running in 32 or 64-bit mode. ARMv8 is the
name of the latest ARM architecture and we expect this number to go up
in the future. It introduces the new 64-bit execution mode with new
exception model and instruction set called AArch64. ARMv8 may also
support the 32-bit (AArch32) mode which is backwards compatible with the
ARMv7 architecture.

The AArch64 mode will most likely be found in future ARM architecture
versions, so breaking the link between the Linux port and the
architecture version is the right thing. For this reason, uname no
longer reports "armv*" in the 64-bit port but simply "aarch64" (for
compat tasks it still uses the old style). CPU features available to
user space are already advertised via the hwcap bits.

That said, the directory name of the Linux port does not have to match
the name of the architecture or execution mode (we had arch/arm26/ until
a few years ago). So I'm ok with renaming the directory to arch/arm64/,
together with the CONFIG_ARM64* symbols. The uname will still report
"aarch64" to match the compiler triplet and also avoid confusion of
existing 32-bit ARM scripts that simply check for "arm*" in the machine
name.

-- 
Catalin
