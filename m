Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0F2PeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:34:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39186 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab0F2PeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:34:16 -0400
Message-ID: <4C2A125B.4050504@zytor.com>
Date: Tue, 29 Jun 2010 08:33:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/alternatives] x86, alternatives: Use 16-bit numbers
 for cpufeature index
References: <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org> <tip-5dc71d49a7c209b77cd257049a2cdb99ed1008c0@git.kernel.org> <20100629091535.GA28302@elte.hu>
In-Reply-To: <20100629091535.GA28302@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 02:15 AM, Ingo Molnar wrote:
> 
> Hm, this patch is causing trouble in -tip testing again - it's triggering a 
> colorful boot crash:
> 
> [    2.220002] calling  inet_init+0x0/0x23d @ 1
> [    2.223343] NET: Registered protocol family 2
> [    2.226727] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    2.233492] ------------[ cut here ]------------
> [    2.236671] WARNING: at mm/vmalloc.c:107 vmap_page_range_noflush+0x309/0x3a0()
> [    2.240001] Modules linked in:
> ...
> [    3.090002] Kernel panic - not syncing: Failed to allocate TCP established hash table
> 
> So i've zapped them again. We really need to get to the bottom of this. Config 
> and bootlog attached.
> 
> The crash looks very weird - and it's consistent with possible effects of some 
> sort of code patching failure/mismatch.
> 
> It goes away if i revert these two:
> 
>  a3d2d12: x86, alternatives: correct obsolete use of "u8" in static_cpu_has()
>  5dc71d4: x86, alternatives: Use 16-bit numbers for cpufeature index
> 
> I reproduced the crash twice before testing the revert.
> 

Hi Ingo,

I'm pretty sure that these are related to gcc and/or binutils
differences, so it would be nice to get the .o and .s files of the
failing locations (in this case mm/vmalloc.[so]) *as built on the
failing machines*.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

