Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2IXHvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:51:15 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:36315 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754964Ab2IXHvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:51:13 -0400
Message-ID: <50601131.10602@ti.com>
Date: Mon, 24 Sep 2012 10:52:17 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound and sound-asoc
 trees
References: <20120924133923.130c4db72aa8105cb5647d7a@canb.auug.org.au> <s5hy5jzoo8d.wl%tiwai@suse.de>
In-Reply-To: <s5hy5jzoo8d.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 10:48 AM, Takashi Iwai wrote:
> At Mon, 24 Sep 2012 13:39:23 +1000,
> Stephen Rothwell wrote:
>>
>> Hi all,
>>
>> After merging the sound tree, today's linux-next build (powerpc
>> ppc64_defconfig) failed like this:
>>
>> In file included from include/linux/skbuff.h:31:0,
>>                  from include/linux/if_ether.h:135,
>>                  from include/linux/netdevice.h:29,
>>                  from arch/powerpc/net/bpf_jit_comp.c:14:
>> include/linux/dmaengine.h: In function 'dmaengine_prep_dma_cyclic':
>> include/linux/dmaengine.h:659:24: error: 'flags' undeclared (first use in this function)
>>
>> and lots more similar.
>>
>> Caused by commit ec8b5e48c037 ("dmaengine: Pass flags via
>> device_prep_dma_cyclic() callback").  Was this version of this patch
>> build tested at all?
>>
>> I have used the sound and sound-asoc trees from next-20120921 for today.
> 
> Ugh, sorry.  I skipped the ppc and arm build tests at the previous
> merge due to the remote work.
> 
> I can fix up but it'd be better to get a proper fix from Peter.
> Peter, could you submit the fix ASAP?

I already have the series to fix it.
The reason for the build breakage is that the following commit from my series
got lost somewhere:
dmaengine: Add flags parameter to dmaengine_prep_dma_cyclic()

I also noticed that arch/arm/plat-samsung/dma-ops.c calls
dmaengine_prep_dma_cyclic(), which was unexpected for me. So I have two patch
for linux-next/sound to fix the issue.

Will send them in a minute.

-- 
Péter
