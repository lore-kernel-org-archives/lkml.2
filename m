Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab2IRNS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:18:58 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:37998
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755830Ab2IRNS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:18:56 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz98dI1432I4015I179dNd6f1izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAJRNE-02-NE7-02
X-M-MSG: 
Date: Tue, 18 Sep 2012 15:18:42 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jan Luebbe <jlu@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/dma-debug: check for vmalloc buffers used with the
 DMA-API
Message-ID: <20120918131842.GL2505@amd.com>
References: <1346670004-10248-1-git-send-email-jlu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346670004-10248-1-git-send-email-jlu@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 01:00:04PM +0200, Jan Luebbe wrote:
> Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
> ---
> I'm not sure why we don't check for high memory, is there any problem
> with this approach?
> 
>  lib/dma-debug.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 66ce414..7d60ff0 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -944,6 +944,9 @@ static void check_for_illegal_area(struct device *dev, void *addr, unsigned long
>  	if (overlap(addr, len, _text, _etext) ||
>  	    overlap(addr, len, __start_rodata, __end_rodata))
>  		err_printk(dev, NULL, "DMA-API: device driver maps memory from kernel text or rodata [addr=%p] [len=%lu]\n", addr, len);
> +	if (is_vmalloc_or_module_addr(addr) ||
> +	    is_vmalloc_or_module_addr(addr+len))
> +		err_printk(dev, NULL, "DMA-API: device driver maps memory from vmalloc or module address range [addr=%p] [len=%lu]\n", addr, len);

Hmm, this only checks whether the start or end+1 address is in the
vmalloc/module range. I think it is better to check for overlap against
VMALLOC_START/END and do a seperate overlap check for MODULES_VADDR and
MODULES_END when needed.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

