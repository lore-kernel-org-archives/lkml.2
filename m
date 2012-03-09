Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab2CIMEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:04:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36965 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab2CIMEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:04:36 -0500
MIME-Version: 1.0
In-Reply-To: <20120309105645.GA3852@pengutronix.de>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
	<20120309105645.GA3852@pengutronix.de>
Date: Fri, 9 Mar 2012 13:04:36 +0100
Message-ID: <CACKLOr3Y9BW_pMUnr6q4eH2c+2=jQ2WHEjWprb=O5wFrS9=T=A@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] dmaengine: imx-dma: merge dma arch code into dmaengine.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,
thank you for your time.

On 9 March 2012 11:56, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Wed, Mar 07, 2012 at 03:33:32PM +0100, Javier Martin wrote:
>> The following series have to be applied on top of the following patches:
>> [PATCH v2 1/2] dmaengine: Add support for MEMCPY for imx-dma.
>> [PATCH v3 2/2] dmaengine: Add support for multiple descriptors for imx-dma.
>>
>> As discussed with Vinod and Sascha, the file 'arch/arm/mach-imx/dma-v1.c'
>> is deprecated and no new patches are accepted for it.
>>
>> This series merges this code into the imx-dma.c dmaengine driver.
>>
>> Changes since v1:
>>  - Merge patch 14 with 01.
>>  - Add a proper changelog to each patch of the series.
>>
>> [PATCH v2 01/13] dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c
>> [PATCH v2 02/13] dmaengine: imx-dma: remove data member from internal structure.
>> [PATCH v2 03/13] dmaengine: imx-dma: remove dma_mode member of internal structure.
>> [PATCH v2 04/13] dmaengine: imx-dma: remove 'imxdma_setup_mem2mem_hw' function.
>> [PATCH v2 05/13] dmaengine: imx-dma: remove 'imxdma_config_channel_hw' function.
>> [PATCH v2 06/13] dmaengine: imx-dma: remove 'imxdma_setup_sg_hw' function.
>> [PATCH v2 07/13] dmaengine: imx-dma: remove sg member from internal structure.
>> [PATCH v2 08/13] dmaengine: imx-dma: remove 'in_use' field of 'internal' structure.
>> [PATCH v2 09/13] dmaengine: imx-dma: remove 'resbytes' field of 'internal' structure.
>> [PATCH v2 10/13] dmaengine: imx-dma: remove internal structure.
>> [PATCH v2 11/13] dmaengine: imx-dma: remove unused arg of imxdma_sg_next.
>> [PATCH v2 12/13] dmaengine: imx-dma: remove 'imx_dmav1_baseaddr' and 'dma_clk'.
>> [PATCH v2 13/13] dmaengine: imx-dma: use 'dev_dbg' and 'dev_warn' for messages.
>
> I didn't look at the individual patches but only on the end result and
> overall it looks good. There are several things left for further cleanup:
>
> - use resources for irq and base address
> - use platform device id rather than cpu_is_* to distinguish
>  between the different device types.
> - request_irq for i.MX21/27 in alloc_chan_resources instead in probe
> - Use all available channels. In the time we had dmaengine users and
>  legacy API users 8 channels were reserved for the old API and 8
>  channels for the dmaengine API.
>
> I think the first three points can be done in a later series, the last
> one should be trivial to fix now.

I agree. Let me fix the last issue you mention in a v3 of the involved patch.

> Some comments follow to the individual patches.
>
> And, oh:
>
> Tested-by: Sascha Hauer <s.hauer@pengutronix.de

Cool. Did you test it for any other platform than i.MX27?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
