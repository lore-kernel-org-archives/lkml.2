Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1H3MTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:19:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1H3MTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:19:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: RFD: x32 ABI system call numbers
Date: Tue, 30 Aug 2011 14:18:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kyle Moffett <kyle@moffetthome.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <4E582577.2060805@zytor.com> <4E5C6ADA.3030409@zytor.com> <CAMuHMdUJVRNPcBW60UZ+cwV75T9+xmONzTrCuDCe_dDUzg2kKg@mail.gmail.com>
In-Reply-To: <CAMuHMdUJVRNPcBW60UZ+cwV75T9+xmONzTrCuDCe_dDUzg2kKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301418.50460.arnd@arndb.de>
X-Provags-ID: V02:K0:JxJpD9/mI9MQxIpPE7oHoB/aJL3ahdIcxpwwX8iYX/2
 OHs6tDahIFj/iimlpM72MY/2U+rW4VtiZ3olRMIYo5R7Pue1gh
 SMUc6twTM+J1YYs+Nr76WXioZOIiZJVKIYwh2DAE5YSlDUw/YV
 ovFlVwUvmUqXHUh3aOmNk+URwImxiGGIpax0VgBSHxuMougjZe
 dVCBOly7vksh+tz0PuAUo/trNRnGjZJMttoP2CtlJDRqlX377t
 vokjf97hBrv2+IukOcvrrF0mw9E4yiVuWE6tJw4DUHkciPpgbV
 nkEeelUbdx4K8NnSAzQ2a9MazVdtC0VdCNx3tvU94JcB/VftDX
 LBbrw4Gps9HllCDVOwu0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Geert Uytterhoeven wrote:
> On Tue, Aug 30, 2011 at 06:45, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 08/29/2011 07:16 PM, Kyle Moffett wrote:
> >> The goal of x32 as I understand it is to allow 32-bit x86 programs to
> >> use all the nifty extra registers and faster instructions (IE: syscall)
> >> without needing to deal with the 2x memory overhead of 64-bit
> >> pointers.
> 
> Good. IIRC, the PPC people were thinking about something similar back in 2007,
> but it hasn't materialized yet.

I think every arch has thought about it at some point. Note that current powerpc
(and s390) enterprise systems are 64 bit only. s390 wants to add a new 32 bit
ABI along these lines (much simpler to do than on x86 though). MIPS has
had it for a long time (the n32 ABI).

For sh and tile, the 32-on-64 ABI still uses the 64 bit registers all the
time and is incompatible with the native 32 bit ABI.

> > That is the major goal.  A minor goal is to bring x86-64 goodness to
> > those who have an (irrational) fear of 64 bits thinking it is a major
> > porting effort.  Thus, *source-level* porting effort matters, but it is
> > completely subordinate to the major goal.
> 
> From my experience, if the source code is not 64-bit clean, it will probably
> be a major hassle to make it cope with changed time_t and off_t and other traps
> of that kind...

I don't think so. The only major user space projects that I've seen being
fundamentally 32-bit only are the ones that have some kind of language
interpreter that casts freely between pointers and 32 bit wide integers.

The uses of time_t and off_t are typically fairly localized in the programs
by comparison and can be fixed much easier, especially if you don't actually
want to use larger than 32 bit values for these.

	Arnd
