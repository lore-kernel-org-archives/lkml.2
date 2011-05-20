Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944Ab1ETHNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:13:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50942 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933880Ab1ETHN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:13:28 -0400
Message-ID: <B7F8B2D7C5D5428B911477CBC0320090@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: "Greg KH" <greg@kroah.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>, <sachi@mistralsolutions.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <78EB813416554F1A973EF20AA714ADF8@subhasishg> <B85A65D85D7EB246BE421B3FB0FBB593024CF13FC2@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024CF13FC2@dbde02.ent.ti.com>
Subject: Re: [PATCH v4 08/11] tty: add pruss SUART driver
Date: Fri, 20 May 2011 12:44:00 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

>> > ok, so what you are suggesting is that I implement some
>> > callbacks (like .fifo_alloc, .fifo_dealloc) which can allocate
>> > memory using sram_alloc.
>> > My doubt is, if already such API's are there (by Russel) or you
>> > are suggesting to implement them.
>>
>> I can add the fifo_alloc/dealloc as part of the suart platform_data,
>> Is that's what you are suggesting. If you may please point me out
>> to any example. I am just not clear with this.
>
> Yes, that's what I am suggesting. I don't have an exact example
> for you, but for an example of how function pointers can be passed
> along in platform data you can look at the platform data for
> DA8x FB driver in include/video/da8xx-fb.h.
>

Does this look ok.
This code snippet is in the driver file.

        if (soft_uart->use_sram) {
                soft_uart->suart_iomap.p_fifo_buff_virt_base =
                pdata->fifo_alloc(SUART_CNTX_SZ * NR_SUART * 2,
                (dma_addr_t *) 
&soft_uart->suart_iomap.p_fifo_buff_phys_base);
                if (!soft_uart->suart_iomap.p_fifo_buff_virt_base) {
                        soft_uart->suart_iomap.p_fifo_buff_virt_base =
                        dma_alloc_coherent(&pdev->dev,
                        SUART_CNTX_SZ * NR_SUART * 2,
                        (dma_addr_t *) &soft_uart->suart_iomap.
                        p_fifo_buff_phys_base, GFP_KERNEL);
                        soft_uart->use_sram = false;
                        if (!soft_uart->suart_iomap.p_fifo_buff_virt_base)
                                goto probe_exit_iounmap;
                }
        } else {
                soft_uart->suart_iomap.p_fifo_buff_virt_base =
                dma_alloc_coherent(&pdev->dev,
                SUART_CNTX_SZ * NR_SUART * 2,
                (dma_addr_t *) &soft_uart->suart_iomap.
                p_fifo_buff_phys_base, GFP_KERNEL);
                if (!soft_uart->suart_iomap.p_fifo_buff_virt_base)
                        goto probe_exit_iounmap;
        }

I added the fifo_alloc into the suart_data of the board file.

static struct da850_evm_pruss_suart_data suart_data = {
        .version        = 1,
        .setup          = da850_evm_pruss_suart_setup,
        .fifo_alloc     = sram_alloc,
        .fifo_free      = sram_free,
};

Best Regards,
Subhasish Ghosh
 

