Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1EBTFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:05:39 -0400
Received: from christianhoffmann.info ([88.175.101.52]:57708 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1EBTFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:05:38 -0400
X-Greylist: delayed 961 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 15:05:38 EDT
Message-ID: <4DBEFCBA.3070501@christianhoffmann.info>
Date: Mon, 02 May 2011 20:49:30 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: johnstul@us.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Long timeout when booting >= 2.6.38
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a strange hang/timeout when booting kernel 2.6.38 and newer. It 
hangs after a few initialization steps and then after 145 seconds, it 
continues to boot.

I bisected kernel and found that offensive revision is:

08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
"x86: Improve TSC calibration using a delayed workqueue"

Older kernels before above revision work fine.

When passing acpi=off to kernel, the problem seems to disappear.

Dmesg output below where you can see the jump from 1.47 to 146.85.

The mainboard is an Asus M4A89GTD PRO/USB3 (latest BIOS revision).

Kind regards,
Chris

PS: the problem has also been reported to ubuntu where more hw 
information is attached.
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/765230
PSS: dmesg output

[ 1.473495] pci_bus 0000:04: resource 4 [io 0x0000-0x0cf7]
[ 1.473496] pci_bus 0000:04: resource 5 [io 0x0d00-0xffff]
[ 1.473497] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[ 1.473499] pci_bus 0000:04: resource 7 [mem 0x000d0000-0x000dffff]
[ 1.473500] pci_bus 0000:04: resource 8 [mem 0xcff00000-0xdfffffff]
[ 1.473502] pci_bus 0000:04: resource 9 [mem 0xf0000000-0xfebfffff]
[ 1.473504] pci_bus 0000:05: resource 0 [io 0xe000-0xefff]
[ 1.473505] pci_bus 0000:05: resource 1 [mem 0xfe900000-0xfe9fffff]
[ 1.473506] pci_bus 0000:05: resource 2 [mem 0xfdf00000-0xfdffffff64bit 
pref]
[ 1.473528] NET: Registered protocol family 2
[ 1.473742] IP route cache hash table entries: 262144 (order: 9, 097152 
bytes)
[ 1.474749] TCP established hash table entries: 524288 (order: 11, 
8388608 bytes)
[ 1.476599] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[ 1.476906] TCP: Hash tables configured (established 524288 bind 65536)
[ 1.476956] TCP reno registered
[ 1.476991] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[ 1.477058] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes) [ 
1.477185] NET: Registered protocol family 1
[ 1.477217] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[ 146.850204] pci 0000:01:05.0: Boot video device
[ 146.850243] PCI: CLS 64 bytes, default 64
[ 146.851583] PCI-DMA: Disabling AGP.
[ 146.851722] PCI-DMA: aperture base @ c4000000 size 65536 KB
[ 146.851749] PCI-DMA: using GART IOMMU.
[ 146.851776] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture 
[ 146.855705] audit: initializing netlink socket (disabled)
[ 146.855751] type=2000 audit(1303051325.840:1): initialized
[ 146.864990] HugeTLB registered 2 MB page size, pre-allocated 0 pages [ 
146.866277] VFS: Disk quotas dquot_6.5.2
[ 146.866368] Dquot-cache hash table entries: 512 (order 0, 4096 bytes) 
[ 146.866903] fuse init (API version 7.16)
[ 146.866979] msgmni has been set to 15492
[ 146.867311] Block layer SCSI generic (bsg) driver version 0.4 loaded ...
