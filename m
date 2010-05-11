Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab0EKVJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:09:49 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59223 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0EKVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:09:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nlTXiXDveg68Cntzn6LaWh0qjirWLnKol+OFEPufLTwhBM5ncJT/gxkxA8PlIMtXh7
         Wo0LBDcCkDAkoEu/glIMSt7BgTWRoqYh3Sy35eEPd/Tc5TQv1GJDscw+QTCFEL0f7zUZ
         noi5nR4Pbf4FRzaElZX/7ahI1Eh1KA/EyzhgQ=
Message-ID: <4BE9C796.7080605@garzik.org>
Date: Tue, 11 May 2010 17:09:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Phil Turmel <pturmel-kernel@turmel.org>
CC: Phil Reynolds <phil-linux@tinsleyviaduct.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com> <4BE964C2.1010702@turmel.org> <20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com> <4BE9A1B3.3020208@turmel.org>
In-Reply-To: <4BE9A1B3.3020208@turmel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 02:28 PM, Phil Turmel wrote:
> On 05/11/2010 01:21 PM, Phil Reynolds wrote:
>> Quoting "Phil Turmel"<pturmel-kernel@turmel.org>:
>>
>>> I have a similar chipset in my office server: 88SE6145.  If yours can run
>>> in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel
>>> command
>>> line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I have
>>> ahci built-in, and no initramfs, so I put the option in my grub.conf.)
>>
>> Neither works for me unfortunately.
>>
>
> Hmmm.  If you post your dmesg, lspci, and config, I'll be happy to compare
> to my setup.  It might be something as simple as the Marvell driver loading
> first and claiming the device.
>
> The relevant part of my dmesg looks like this:
>
> [    4.802703] ahci 0000:06:00.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
> [    4.806351] ahci 0000:06:00.0: controller can't do NCQ, turning off CAP_NCQ
> [    4.809921] ahci 0000:06:00.0: controller can't do PMP, turning off CAP_PMP
> [    4.813334] ahci 0000:06:00.0: MV_AHCI HACK: port_map 1f ->  f
> [    4.816656] ahci 0000:06:00.0: Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.
> [    4.823333] ahci: SSS flag set, parallel bus scan disabled
> [    4.826765] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 5 ports 3 Gbps 0xf impl RAID mode
> [    4.830240] ahci 0000:06:00.0: flags: 64bit stag slum part
> [    4.833810] ahci 0000:06:00.0: setting latency timer to 64
> [    4.834021] scsi4 : ahci
> [    4.837755] scsi5 : ahci
> [    4.841426] scsi6 : ahci
> [    4.844997] scsi7 : ahci
> [    4.848509] scsi8 : ahci
> [    4.851956] ata5: SATA max UDMA/133 irq_stat 0x02400000, PHY RDY changed irq 17
> [    4.855423] ata6: SATA max UDMA/133 irq_stat 0x02400000, PHY RDY changed irq 17
> [    4.858814] ata7: SATA max UDMA/133 abar m1024@0xfbfffc00 port 0xfbfffe00 irq 17
> [    4.862177] ata8: SATA max UDMA/133 abar m1024@0xfbfffc00 port 0xfbfffe80 irq 17
> [    4.865472] ata9: DUMMY
>
> The Marvell driver never gets a chance to claim my device, as it is disabled in
> my kernel config.  If you are using modules, you might want to blacklist "sata_mv".

sata_mv is not related to this hardware.

pata_marvell works with 6101/6121/6141/6145 PATA ports.

ahci works with 6101/6121/6141/6145 SATA ports, with marvell_enable=1.

	Jeff




