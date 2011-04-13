Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab1DMTfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:35:03 -0400
Received: from 8bytes.org ([88.198.83.132]:39018 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757720Ab1DMTfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:35:00 -0400
Date: Wed, 13 Apr 2011 21:34:59 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110413193459.GL19819@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA5F62F.3030504@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 12:14:55PM -0700, Yinghai Lu wrote:
> thanks for the bisecting...
> 
> so those two patches uncover some problems.
> 
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Node 0: aperture @ a0000000 size 32 MB
> [    0.000000] Aperture pointing to e820 RAM. Ignoring.
> [    0.000000] Your BIOS doesn't leave a aperture memory hole
> [    0.000000] Please enable the IOMMU option in the BIOS setup
> [    0.000000] This costs you 64 MB of RAM
> [    0.000000]     memblock_x86_reserve_range: [0xa0000000-0xa3ffffff]       aperture64
> [    0.000000] Mapping aperture over 65536 KB of RAM @ a0000000
> 
> so kernel try to reallocate apperture. because BIOS allocated is pointed to RAM or size is too small.

It is actually beyond 4GB on that machine, this value read here is from
the previous kernel-boot. The BIOS does not reset these values on a
reboot.

> but your radeon does use [0xa0000000, 0xbfffffff)

Yes, I suspected that too (and spent a few hours reading radeon code),
but then I talked the Alex Deucher and he explained that these addresses
which the driver prints for GTT and VRAM are in the GPU address space
and do not refer to system ram. So this shouldn't be the problem.

	Joerg

