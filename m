Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1KRFDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:03:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45538 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab1KRFDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:03:16 -0500
Message-ID: <4EC5E6FD.8040902@zytor.com>
Date: Thu, 17 Nov 2011 21:02:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: wangyanqing <Udknight@gmail.com>, torvalds@linux-foundation.org,
        castet.matthieu@free.fr, akpm@linux-foundation.org, x86@kernel.org,
        spock@gentoo.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: remove NX from video bios area
References: <20111117082624.GA4136@udknight.homenetwork> <4EC520AE.3070409@zytor.com> <20111118044515.GA17250@udknight.homenetwork>
In-Reply-To: <20111118044515.GA17250@udknight.homenetwork>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 08:45 PM, wangyanqing wrote:
> Sorry for my bad idea!

Don't worry... the important thing is that we have a real problem and
we're trying to figure it out.

> Indeed v86d have double backend to execute x86 video bios code,
> one is lrmi(linux real mode interface), another is x86emu.Yesterday,
> I compile the v86d with x86emu.Below is the new maps:
> 
> 08048000-0805e000 r-xp 00000000 00:01 3324       /sbin/v86d 
> 0805e000-0805f000 rw-p 00015000 00:01 3324       /sbin/v86d 
> 0805f000-08060000 rw-p 00000000 00:00 0 
> b7713000-b7733000 rw-s 000e0000 00:01 3234       /dev/mem 
> b7733000-b7742000 rw-s 000c0000 00:01 3234       /dev/mem 
> b7742000-b7762000 rw-s 000a0000 00:01 3234       /dev/mem 
> b7762000-b7763000 rw-s 0009c000 00:01 3234       /dev/mem 
> b7763000-b7764000 rw-s 00000000 00:01 3234       /dev/mem 
> b7764000-b7784000 rw-p 00000000 00:01 3230       /dev/zero
> b7784000-b7785000 r-xp 00000000 00:00 0          [vdso]
> bf98a000-bf9ab000 rw-p 00000000 00:00 0          [stack]
> 
> As you see,  now v86d doesn't need the X permission.But 
> my machine still hang very early(verbose show uvesafb some 
> messages, then black screen, it hangs!)
> 
> But if I make the BIOS range X unconditionally, the problem is gone.
> So we need more hacky.Any comment is welcome.

Is there any way you can hook up a serial console to your machine?  I
suspect that we're getting a kernel panic that we're not seeing.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

