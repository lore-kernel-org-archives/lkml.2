Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab1DMSwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:52:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42506 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757037Ab1DMSwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:52:13 -0400
Message-ID: <4DA5F0BB.1000308@zytor.com>
Date: Wed, 13 Apr 2011 11:51:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org>
In-Reply-To: <20110413172147.GI19819@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 10:21 AM, Joerg Roedel wrote:
> 
> First of all, I bisected between v2.6.37-rc2..f005fe12b90c which where
> only a couple of patches and merged v2.6.38-rc4 in at every step. There
> was no failure found.
> Then I tried this again, but this time I merged v2.6.38-rc5 at every
> step and was successful. The bad commit in this branch turned out to be
> 
> 	1a4a678b12c84db9ae5dce424e0e97f0559bb57c
> 
> which is related to memblock.
> 
> Then I tried to find out which change between 2.6.38-rc4 and 2.6.38-rc5
> is needed to trigger the failure, so I used f005fe12b90c as a base,
> bisected between v2.6.38-rc4..v2.6.38-rc5 and merged every bisect step
> into the base and tested. Here the bad commit turned out to be
> 
> 	e6d2e2b2b1e1455df16d68a78f4a3874c7b3ad20
> 
> which is related to gart. It turned out that the gart aperture on that
> box is on another position with these patches. Before it was as
> 0xa4000000 and now it is at 0xa0000000. It seems like this has something
> to do with the root-cause.
> 
> Reverting commit 1a4a678b12c84db9ae5dce424e0e97f0559bb57c fixes the
> problem btw. and booting with iommu=soft also works, but I have no idea
> yet why the aperture at that address is a problem (with the patch
> reverted the aperture lands at 0x80000000).
> 

Does reverting e6d2e2b2b1e1455df16d68a78f4a3874c7b3ad20 solve the
problem for you?

1a4a678b12c84db9ae5dce424e0e97f0559bb57c is a memory-allocation-order
patch, which have a nasty tendency to unmask bugs elsewhere in the
kernel.  However, e6d2e2b2b1e1455df16d68a78f4a3874c7b3ad20 looks
positively strange (and it doesn't exactly help that the description is
written in Yinghai-ese and is therefore nearly impossible to decode,
never mind tell if it is remotely correct.)

	-hpa


