Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1KWUiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:38:52 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3134 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964Ab1KWUiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:38:51 -0500
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Wed, 23 Nov 2011 21:38:49 +0100
To: Sasha Levin <levinsasha928@gmail.com>
From: "N. Coesel" <nico@nctdev.nl>
Subject: Re: Fast memcpy patch
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1322053469.3581.17.camel@lappy>
References: <CPSMTPM-CMT101y332G000633f8@CPSMTPM-CMT101.kpnxchange.com>
 <1322050241.3581.15.camel@lappy>
 <CPSMTPM-CMT109vpIa300062dcf@CPSMTPM-CMT109.kpnxchange.com>
 <1322053469.3581.17.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Message-ID: <CPSMTPM-CMT1090lfep000656f3@CPSMTPM-CMT109.kpnxchange.com>
X-OriginalArrivalTime: 23 Nov 2011 20:38:50.0251 (UTC) FILETIME=[E82775B0:01CCAA1F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha,

At 14:04 23-11-2011, Sasha Levin wrote:
>On Wed, 2011-11-23 at 13:51 +0100, N. Coesel wrote:
> > Sasha,
> >
> > At 13:10 23-11-2011, Sasha Levin wrote:
> > >On Wed, 2011-11-23 at 12:25 +0100, N. Coesel wrote:
> > > > Dear readers,
> > > > I noticed the Linux kernel still uses a byte-by-byte copy method for
> > > > memcpy. Since most memory allocations are aligned to the integer size
> > > > of a cpu it is often faster to copy by using the CPU's native word
> > > > size. The patch below does that. The code is already at work in many
> > > > 16 and 32 bit embedded products. It should also work for 64 bit
> > > > platforms. So far I only tested 16 and 32 bit platforms.
> > >
> > >[snip]
> > >
> > >memcpy (along with other mem* functions) are arch specific - for
> > >example, look at arch/x86/lib/memcpy_64.S for the implementation(s) for
> > >x86.
> > >
> > >The code under lib/string.c is simple and should work on all platforms
> > >(and is probably not being used anywhere anymore).
> >
> > Thanks for pointing that out. Currently my primary target is ARM. It
> > seems the memcpy for that arch uses byte-by-byte copying as well with
> > some loop unrolling. I modified the code so it tries to use
> > word-by-word copy if the pointers are aligned on word boundaries, if
> > not it reverts to the old method. For clarity: by word I mean the
> > CPU's native bus width. In case of ARM that's (still) 32 bit.
>
>I don't think we're looking at the same file.
>
>For arm it's arch/arm/lib/copy_template.S, right? Or are you talking
>about something else?

I was looking somewhere else indeed. There are a lot of versions of 
memcpy in the kernel :-) Thanks for pointing me to the right file. 
The asm stuff looks pretty nifty by using the load/store multiple 
instructions. Too bad. I was hoping to get some extra speed with a 
quick fix. I need to copy several MB from a driver.

Nico Coesel


>--
>
>Sasha.

