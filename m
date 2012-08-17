Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab2HQR2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:28:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35986 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651Ab2HQR14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:27:56 -0400
Message-ID: <502E7F19.50306@pobox.com>
Date: Fri, 17 Aug 2012 13:27:53 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Hannemann <arnd@arndnet.de>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_atiixp: override cable detection on MSI E350DM-E33
References: <1345191075-30425-1-git-send-email-arnd@arndnet.de>
In-Reply-To: <1345191075-30425-1-git-send-email-arnd@arndnet.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 04:11 AM, Arnd Hannemann wrote:
> The mainboard MSI E350DM-E33 is advertised with 6 SATA ports.
> As it turns out, two of them seem to be driven by on-board
> SATA<->PATA converters. If a disk drive is connected to one
> of them kernel uses UDMA/33 mode due to cable detection:
>
> [   34.550823] scsi4 : pata_atiixp
> [   34.555517] scsi5 : pata_atiixp
> [   34.555942] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf100 irq 14
> [   34.555948] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf108 irq 15
> ...
> [   35.040799] ata5.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
> [   35.040806] ata5.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [   35.040817] ata5.00: limited to UDMA/33 due to 40-wire cable
> [   35.049166] ata5.00: configured for UDMA/33
> [   35.049402] scsi 4:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
>
> This patch forces "short cable" mode on this board, as it seems clear that
> the on-board SATA<->PATA "cable" is short.
> With this patch the disk is configured for UDMA/100:
>
> [    5.976756] ata5.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
> [    5.996434] ata5.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    6.024787] ata5.00: configured for UDMA/100
>
> Testing revealed no transfer issues.
>
> Signed-off-by: Arnd Hannemann <arnd@arndnet.de>

applied



