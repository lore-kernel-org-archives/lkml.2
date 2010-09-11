Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab0IKKnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 06:43:18 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:56968 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab0IKKnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 06:43:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19595.23873.90306.656565@pilspetsen.it.uu.se>
Date: Sat, 11 Sep 2010 12:43:13 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to determine the information about SATA controller
In-Reply-To: <AANLkTimMxQXxC354V=qVOrdUYFSrpJ-RZeKJfQEx0KPN@mail.gmail.com>
References: <AANLkTimMxQXxC354V=qVOrdUYFSrpJ-RZeKJfQEx0KPN@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput writes:
 > Hello,
 > 
 > My old IDE hard disk is broken so I installed new SATA drive on my box with F13:
 > 
 > dmesg :
 > http://userweb.kernel.org/~jaswinder/P4_HT/dmesg_2633_fc13.txt
 > 
 > lsmod:
 > http://userweb.kernel.org/~jaswinder/P4_HT/lsmod_2633_fc13.txt
 > 
 > lspci:
 > 00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM
 > Controller/Host-Hub Interface (rev 02)
 > 00:02.0 VGA compatible controller: Intel Corporation 82865G Integrated
 > Graphics Controller (rev 02)
 > 00:06.0 System peripheral: Intel Corporation 82865G/PE/P Processor to
 > I/O Memory Interface (rev 02)
 > 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
 > 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC
 > Interface Bridge (rev 02)
 > 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
 > Controller (rev 02)
 > 00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02)
 > 
 > I am trying to build the kernel with this config:
 > http://userweb.kernel.org/~jaswinder/P4_HT/config-ht-test.txt
 > 
 > But I am getting error :
 > 
 > No root device found.
 > Boot has failed, sleeping forever
 > 
 > I am trying to determine the information about the SATA controller so
 > that I can choose the appropriate controller for SATA in kernel
 > config. I am not able to figure out the SATA information from above
 > dmesg and lsmod. How can I do so.

In your working dmesg the disks are controlled by ata_piix,
but you've disabled CONFIG_ATA_PIIX in the config you're trying.
So it's not surprising that you can't boot.

1) re-enable CONFIG_ATA_PIIX and disable CONFIG_IDE
or
2) go into the bios and change the option that says whether to run
   the ATA controller in legacy/compatible mode or enhanced/ahci mode,
   you want ahci mode
