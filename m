Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2EZQix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 12:38:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37910 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab2EZQiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 12:38:52 -0400
Message-ID: <4FC1070B.2040403@gmail.com>
Date: Sun, 27 May 2012 00:38:35 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
CC: Dan Williams <dan.j.williams@intel.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/7] dmaengine: enhance dmaengine to support DMA
 device hotplug
References: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com> <20120525094919.078fdff9.izumi.taku@jp.fujitsu.com>
In-Reply-To: <20120525094919.078fdff9.izumi.taku@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Taku,
	Sorry, forgot to export the percpu variable. Could you please
help to test the patch below?
	Thanks!
---
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 8a41bdf..26316f6 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -73,6 +73,7 @@ static atomic_t dmaengine_dirty;
 static struct static_key dmaengine_quiesce = STATIC_KEY_INIT_FALSE;
 static DECLARE_WAIT_QUEUE_HEAD(dmaengine_wait_queue);
 DEFINE_PER_CPU(long, dmaengine_chan_ref_count);
+EXPORT_PER_CPU_SYMBOL(dmaengine_chan_ref_count);
 #endif /* CONFIG_DMA_ENGINE_HOTPLUG */
 
 /* --- sysfs implementation --- */

On 05/25/2012 08:49 AM, Taku Izumi wrote:
> Hi Jiang,
> 
>  Build failed with "Device Drivers/DMA Engine Support/Async_tx: Offload
>   support for the async_tx api" enabled because of undefined symbol. 
>  Patch 5/7 needs a fix?
> 
> (snip)
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CHK     include/linux/version.h
> make[2]: Nothing to be done for `all'.
>   Building modules, stage 2.
>   TEST    posttest
>   MODPOST 2201 modules
> Succeed: decoded and checked 1356146 instructions
>   TEST    posttest
> Success: decoded and checked 1000000 random instructions with 0 errors (seed:0x9432fb9e)
> Kernel: arch/x86/boot/bzImage is ready  (#13)
> ERROR: "dmaengine_chan_ref_count" [crypto/async_tx/async_xor.ko] undefined!
> ERROR: "dmaengine_chan_ref_count" [crypto/async_tx/async_raid6_recov.ko] undefined!
> ERROR: "dmaengine_chan_ref_count" [crypto/async_tx/async_pq.ko] undefined!
> ERROR: "dmaengine_chan_ref_count" [crypto/async_tx/async_memcpy.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Best regards,
> Taku Izumi <izumi.taku@jp.fujitsu.com>
> 

