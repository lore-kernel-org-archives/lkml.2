Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0L1Xvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 18:51:46 -0500
Received: from smtprelay03.ispgateway.de ([80.67.29.7]:46720 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0L1Xvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 18:51:45 -0500
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Dec 2010 18:51:44 EST
Message-ID: <4D1A7628.3050704@steffen-moser.de>
Date: Wed, 29 Dec 2010 00:43:36 +0100
From: Steffen Moser <lists@steffen-moser.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: IOMMU and DMA mode of pata_jmicron
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Df-Sender: lists@steffen-moser.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've encountered a problem with my AMD 890FX based system
and linux-2.6.35.10 (x86_64 platform).

After activating the option "IOMMU" in the mainboard's BIOS
setup, the onboard P-ATA controller "JMicron Technology Corp.
JMB361 AHCI/IDE (rev 02)" puts itself back in the PIO mode.
When loading the module, the kernel reports:

  pata_jmicron 0000:06:00.1: BMDMA: failed to set dma mask, \
                             falling back to PIO

This results, as expected, in a much too low data throughput
between the system and the optical drives connected to the
P-ATA controller.

As soon as I deactivate IOMMU in BIOS setup, the P-ATA channel
runs in the DMA mode again. The S-ATA controllers don't seem
to be affected.

My question is: Is this a known behavior? Are there any
things I have to consider when activating IOMMU (which seems
to be AMD-Vi) on an 890FX based system? Is it a problem of
the chipset and/or the controller or is it related to a
problem in the libata area?

Some information about the affected system:

 - Mainboard:    ASUS M4A89TD Pro/USB3
 - BIOS version: 1101 (most recent version)
 - Chipset:      AMD 890FX
 - Processor:    AMD Phenom 1090T
 - Memory:       4 x 4 GB (Kingston KVR1333D3E9S/4G)
 - Distribution: openSUSE 11.3
 - Kernel:       2.6.35.10 (from "kernel.org"), x86_64

Earlier versions of 2.6.35.x are affected, too. I haven't
tested other kernel versions besides 2.6.35.x, yet.

If you need further information (log files, information from
"/proc", lspci, and so on), please let me know.

Thank you very much in advance for any hint!

Best regards,
Steffen
