Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0L2BAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 20:00:20 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57103 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0L2BAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 20:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w/KPi52Xjq/KU1ueZethzbyYW0jJV2u0Q0YGlRburfzTEBLZpp4nMC2Ia82OMI5e2K
         2fbQnCoB7Ulf/9HAloeZbhfyKCMELbUVxhQvAbMlvUkSZvgSeKQGRF9+bePxIeRTCuGh
         YwcpdSCSyRkLJvPY3zFUYnWNGlJiggE/ymx6w=
Message-ID: <4D1A881C.3080109@garzik.org>
Date: Tue, 28 Dec 2010 20:00:12 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steffen Moser <lists@steffen-moser.de>
CC: linux-kernel@vger.kernel.org,
        Linux IDE mailing list <linux-ide@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: IOMMU and DMA mode of pata_jmicron
References: <4D1A7628.3050704@steffen-moser.de>
In-Reply-To: <4D1A7628.3050704@steffen-moser.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'd linux-ide, Joerg)

On 12/28/2010 06:43 PM, Steffen Moser wrote:
> I've encountered a problem with my AMD 890FX based system
> and linux-2.6.35.10 (x86_64 platform).
>
> After activating the option "IOMMU" in the mainboard's BIOS
> setup, the onboard P-ATA controller "JMicron Technology Corp.
> JMB361 AHCI/IDE (rev 02)" puts itself back in the PIO mode.
> When loading the module, the kernel reports:
>
>    pata_jmicron 0000:06:00.1: BMDMA: failed to set dma mask, \
>                               falling back to PIO
[...]
> As soon as I deactivate IOMMU in BIOS setup, the P-ATA channel
> runs in the DMA mode again. The S-ATA controllers don't seem
> to be affected.
>
> My question is: Is this a known behavior? Are there any
> things I have to consider when activating IOMMU (which seems
> to be AMD-Vi) on an 890FX based system? Is it a problem of
> the chipset and/or the controller or is it related to a
> problem in the libata area?
>
> Some information about the affected system:
>
>  - Mainboard:    ASUS M4A89TD Pro/USB3
>  - BIOS version: 1101 (most recent version)
>  - Chipset:      AMD 890FX
>  - Processor:    AMD Phenom 1090T
>  - Memory:       4 x 4 GB (Kingston KVR1333D3E9S/4G)
>  - Distribution: openSUSE 11.3
>  - Kernel:       2.6.35.10 (from "kernel.org"), x86_64
>

This condition occurs when the PCI API cannot set the PCI device's DMA 
mask to the 32-bit value
	#define ATA_DMA_MASK            0xffffffffULL

That is an unusual failure for such a modern system, which certainly can 
handle 32-bit masks like that, one would think.

	Jeff



