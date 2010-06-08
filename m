Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab0FHKat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 06:30:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62573 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0FHKas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 06:30:48 -0400
Message-ID: <4C0E1B65.9000603@petalogix.com>
Date: Tue, 08 Jun 2010 12:28:53 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.35-rc3 v2
References: <4C0D3853.60000@petalogix.com> <20100608083015L.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100608083015L.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Mon, 07 Jun 2010 20:20:03 +0200
> Michal Simek <michal.simek@petalogix.com> wrote:
> 
>> Hi Linus,
>>
>> here are only fixes for Microblaze. There is no any new features. 
>> (flush_dcache_page patch fix problem on WB system)
>> Just note: Some new patches broke Microblaze arch that's why I would 
>> like to add at least these patches to your tree.
>>
>> Thanks,
>> Michal
>>
>>
>> The following changes since commit 386f40c86d6c8d5b717ef20620af1a750d0dacb4:
>>    Linus Torvalds (1):
>>          Revert "tty: fix a little bug in scrup, vt.c"
>>
>> are available in the git repository at:
>>
>>    git://git.monstr.eu/linux-2.6-microblaze.git next
>>
>> Michal Simek (7):
>>        microblaze: Fix __copy_to/from_user_inatomic macros
>>        microblaze: Sync noMMU and MMU setup_memory
>>        microblaze: Fix comment for TLB
>>        microblaze: Implement flush_dcache_page macro
>>        microblaze: Enable NEED_SG_DMA_LENGTH
> 
> Sorry, my scatterlist patchset breaks microblaze?

yes, it does.
http://www.monstr.eu/wiki/doku.php?id=log:2010-06-07_12_23_12#folded_17

> 
> Seems that microblaze can simply remove sg->dma_length instead of
> enabling NEED_SG_DMA_LENGTH. If sg->dma_length is always equal to
> sg->length on your architecture, you don't need to waste memory for
> sg->dma_length.

Please correct me if I am wrong. dma_length is used for 64bit machines.
Microblaze is "only" 32bit.

Can you please generate proper patch?

Thanks,
Michal


> 
> 
> diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
> index 9dcd90b..79c7465 100644
> --- a/arch/microblaze/kernel/dma.c
> +++ b/arch/microblaze/kernel/dma.c
> @@ -90,7 +90,6 @@ static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
>  	/* FIXME this part of code is untested */
>  	for_each_sg(sgl, sg, nents, i) {
>  		sg->dma_address = sg_phys(sg) + get_dma_direct_offset(dev);
> -		sg->dma_length = sg->length;
>  		__dma_sync_page(page_to_phys(sg_page(sg)), sg->offset,
>  							sg->length, direction);
>  	}


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
