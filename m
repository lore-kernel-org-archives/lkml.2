Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab2EaNlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:41:40 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:26000
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757948Ab2EaNlj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:41:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VS-12(zz9371I14ffI542M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ahbe9i)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Bhushan Bharat-R65777 <R65777@freescale.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>
CC: "agraf@suse.de" <agraf@suse.de>
Subject: RE: memblock_end_of_DRAM()  return end address + 1
Thread-Topic: memblock_end_of_DRAM()  return end address + 1
Thread-Index: Ac0/HQWP16L7u7IaTN6gp93aPjbXWAAFYbxQ
Date: Thu, 31 May 2012 13:41:34 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D03D5B033@039-SN2MPN1-022.039d.mgd.msft.net>
References: <6A3DF150A5B70D4F9B66A25E3F7C888D03D5AAE2@039-SN2MPN1-022.039d.mgd.msft.net>
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D03D5AAE2@039-SN2MPN1-022.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.67]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some more gentlemen's.	


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Bhushan Bharat-R65777
> Sent: Thursday, May 31, 2012 4:34 PM
> To: linux-mm@kvack.org; linux-kernel@vger.kernel.org
> Cc: agraf@suse.de
> Subject: memblock_end_of_DRAM() return end address + 1
> 
> Hi All,
> 
> memblock_end_of_DRAM() defined in mm/memblock.c returns base_address + size; So
> this is not returning the end_of_DRAM, it is basically returning the end_of_DRAM
> + 1. The name looks to suggest that this returns end address on DRAM.
> 
> IIUC, it looks like that some code assumes this returns the end address while
> some assumes this returns end address + 1.
> 
> Example:
> 1. arch/powerpc/platforms/85xx/mpc85xx_ds.c
> 
> 
> <cut>
> 
> #ifdef CONFIG_SWIOTLB
>         if (memblock_end_of_DRAM() > max) {
>                 ppc_swiotlb_enable = 1;
>                 set_pci_dma_ops(&swiotlb_dma_ops);
>                 ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
>         }
> #endif
> 
> <cut>
> <cut>
> 
> 
> Where  max = 0xffffffff; So we assumes that memblock_end_of_DRAM() actually
> returns end address.
> 
> ------
> 2.
> 
> In arch/powerpc/kernel/dma.c
> 
> 
> static int dma_direct_dma_supported(struct device *dev, u64 mask) { #ifdef
> CONFIG_PPC64
>         /* Could be improved so platforms can set the limit in case
>          * they have limited DMA windows
>          */
>         return mask >= get_dma_offset(dev) + (memblock_end_of_DRAM() - 1);
> 
> 
> <cut>
> 
> It looks to that here we assume base + addr + 1;
> 
> -----------
> 
> 
> Thanks
> -Bharat
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


