Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2E2Itv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:49:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37784 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2E2Itt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:49:49 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Date: Tue, 29 May 2012 17:49:39 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/7] dmaengine: enhance dmaengine to support DMA
 device hotplug
Message-Id: <20120529174939.5ddfe690.izumi.taku@jp.fujitsu.com>
In-Reply-To: <4FC1070B.2040403@gmail.com>
References: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
	<20120525094919.078fdff9.izumi.taku@jp.fujitsu.com>
	<4FC1070B.2040403@gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 May 2012 00:38:35 +0800
Jiang Liu <liuj97@gmail.com> wrote:

> Hi Taku,
> 	Sorry, forgot to export the percpu variable. Could you please
> help to test the patch below?
> 	Thanks!

  Hi Jiang,

  Thank you. 
  This patch can fix my build issue.
 
  Best regards,
  Taku Izumi


> ---
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 8a41bdf..26316f6 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -73,6 +73,7 @@ static atomic_t dmaengine_dirty;
>  static struct static_key dmaengine_quiesce = STATIC_KEY_INIT_FALSE;
>  static DECLARE_WAIT_QUEUE_HEAD(dmaengine_wait_queue);
>  DEFINE_PER_CPU(long, dmaengine_chan_ref_count);
> +EXPORT_PER_CPU_SYMBOL(dmaengine_chan_ref_count);
>  #endif /* CONFIG_DMA_ENGINE_HOTPLUG */
>  
>  /* --- sysfs implementation --- */
> 
> On 05/25/2012 08:49 AM, Taku Izumi wrote:
> > Hi Jiang,
> > 
> >  Build failed with "Device Drivers/DMA Engine Support/Async_tx: Offload
> >   support for the async_tx api" enabled because of undefined symbol. 
> >  Patch 5/7 needs a fix?
> > 
> > (snip)
> >   CHK     include/linux/version.h
> >   CHK     include/generated/utsrelease.h
> >   CALL    scripts/checksyscalls.sh
> >   CHK     include/generated/compile.h
> >   CHK     include/linux/version.h
> > make[2]: Nothing to be done for `all'.
> >   Building modules, stage 2.
> >   TEST    posttest
> >   MODPOST 2201 modules
> > Succeed: decoded and checked 1356146 instructions
> >   TEST    posttest
> > Success: decoded and checked 1000000 random instructions with 0 errors (seed:0x9432fb9e)
> > Kernel: arch/x86/boot/bzImage is ready  (#13)
> > ERROR: "dmaengine_chan_ref_count" [crypto/async_tx/async_xor.ko] undefined!
> > ERROR: "dmaengine_chan_ref_count" [crypto/async_tx/async_raid6_recov.ko] undefined!
> > ERROR: "dmaengine_chan_ref_count" [crypto/async_tx/async_pq.ko] undefined!
> > ERROR: "dmaengine_chan_ref_count" [crypto/async_tx/async_memcpy.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> > 
> > Best regards,
> > Taku Izumi <izumi.taku@jp.fujitsu.com>
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



