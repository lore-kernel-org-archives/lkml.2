Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1FUFA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 01:00:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59813 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab1FUFAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 01:00:24 -0400
Message-ID: <4E002560.90301@linaro.org>
Date: Tue, 21 Jun 2011 10:30:16 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, tony@atomide.com, lethal@linux-sh.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Samreen <samreen@ti.com>
Subject: Re: [PATCH 1/2] config: omap2+: force fb and dss support as built-in
References: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org>	 <1308566761-2850-2-git-send-email-tushar.behera@linaro.org> <1308575086.2076.55.camel@deskari>
In-Reply-To: <1308575086.2076.55.camel@deskari>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 June 2011 06:34 PM, Tomi Valkeinen wrote:
> On Mon, 2011-06-20 at 16:16 +0530, Tushar Behera wrote:
>> In certain board files, there are references to vram related functions
>> which are defined in drivers/video/omap2/vram.c. Because of this direct
>> dependency, CONFIG_FB_OMAP2 should be a built-in feature.
>
> arch/arm/plat-omap/include/plat/vram.h defines dummy inline function in
> case vram.c is not compiled in, so the board files should compile fine.
>
>> As per the current architecture, CONFIG_FB_OMAP2 is dependent on
>> CONFIG_OMAP2_DSS. Hence CONFIG_OMAP2_DSS support should also be selected
>> by default.
>
> The configuration is fine as it is. And anyway, if things do not compile
> when something is configured as a module, the correct fix is hardly just
> changing the feature to be compiled built-in =).
Agreed. :)
I am not an expert in DSS. I just wanted to raise my concern.
>
>> Cc: Tony Lindgren<tony@atomide.com>
>> Cc: Samreen<samreen@ti.com>
>> Signed-off-by: Tushar Behera<tushar.behera@linaro.org>
>> ---
>> arch/arm/mach-omap2/built-in.o: In function `rx51_video_mem_init':
>> linux-linaro-2.6.39/arch/arm/mach-omap2/board-rx51-video.c:97: undefined reference to `omap_vram_set_sdram_vram'
>> arch/arm/plat-omap/built-in.o: In function `omap_reserve':
>> linux-linaro-2.6.39/arch/arm/plat-omap/common.c:66: undefined reference to `omap_vram_reserve_sdram_memblock'
>> arch/arm/plat-omap/built-in.o: In function `omap_detect_sram':
>> linux-linaro-2.6.39/arch/arm/plat-omap/sram.c:179: undefined reference to `omap_vram_reserve_sram'
>> make[1]: *** [.tmp_vmlinux1] Error 1
>> make: *** [sub-make] Error 2
>
> Compiles fine for me. Perhaps you are using some old kernel?
As mentioned in the cover letter, we get this error only if 2/2 is 
applied and 1/2 is not applied.

I tested this by applying 2/2 on v3.0-rc4 and using omap2plus_defconfig.
>
>   Tomi
>
>


-- 
Tushar Behera
