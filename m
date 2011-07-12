Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1GLQBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:01:36 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39854 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1GLQBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:01:35 -0400
Date: Tue, 12 Jul 2011 11:01:15 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Chris Ball <cjb@laptop.org>
cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, matsumur@nts.ricoh.co.jp,
        linux-pci@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
In-Reply-To: <m2wrfofpro.fsf@bob.laptop.org>
Message-ID: <alpine.DEB.2.02.1107121050480.1767@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <1310419715-13254-2-git-send-email-manoj.iyer@canonical.com> <m2wrfofpro.fsf@bob.laptop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chris,

Test System: ThinkPad X220 Tablet, using Sandisk 2GB Class 2 SD, I did not 
see any considerable change in read/write times. Also, tested a Transcend 
MMCPlus 2GB card, before the patch was applied it would not mount the 
card, and would cause IO errors on read/write, but after the patch it 
mounts and works correctly.

Linux u 3.0.0-4-generic-pae #5 SMP Mon Jul 11 20:26:49 UTC 2011 i686 
GNU/Linux

Dmesg outputs:
=== SD ===
[   44.510107] mmc0: new SD card at address 0002
[   44.510292] mmcblk0: mmc0:0002 00000 1.86 GiB
[   44.512408]  mmcblk0: p1
u@u:~/Documents$

=== MMC ===

[  726.510850] mmc0: card 0001 removed
[  731.688463] mmc0: error -110 whilst initialising MMC card
[  731.776506] mmc0: error -110 whilst initialising MMC card
[  731.864157] mmc0: new MMC card at address 0001
[  731.864611] mmcblk0: mmc0:0001 MMC    1.87 GiB
[  731.866047]  mmcblk0: p1
u@u:~/Documents$


============ BEFORE THE PATCH ===============
Sandisk 2GB Class2 SD
=============================================
=== WRITE ===
u@u:~$ ls -lh test.file
-rw-r--r-- 1 u u 10M 2011-07-12 10:19 test.file
u@u:~$ time cp test.file /media/E0FD-1813/copyto

real    0m0.480s
user    0m0.000s
sys     0m0.024s
u@u:~$ time cp test.file /media/E0FD-1813/copyto1

real    0m0.476s
user    0m0.000s
sys     0m0.028s
u@u:~$ time cp test.file /media/E0FD-1813/copyto2

real    0m0.484s
user    0m0.000s
sys     0m0.024s
u@u:~$ time cp test.file /media/E0FD-1813/copyto3

real    0m0.480s
user    0m0.000s
sys     0m0.020s
u@u:~$
u@u:~$ ls -lh /media/E0FD-1813/copyto*
-rw-r--r-- 1 u u 10M 2011-07-12 10:20 /media/E0FD-1813/copyto
-rw-r--r-- 1 u u 10M 2011-07-12 10:20 /media/E0FD-1813/copyto1
-rw-r--r-- 1 u u 10M 2011-07-12 10:20 /media/E0FD-1813/copyto2
-rw-r--r-- 1 u u 10M 2011-07-12 10:20 /media/E0FD-1813/copyto3
u@u:~$

=== READ ===
u@u:~$ time cp /media/E0FD-1813/copyto1 /tmp/copyfrom1

real    0m0.017s
user    0m0.000s
sys     0m0.016s
u@u:~$ time cp /media/E0FD-1813/copyto1 /tmp/copyfrom2

real    0m0.021s
user    0m0.004s
sys     0m0.020s
u@u:~$ time cp /media/E0FD-1813/copyto1 /tmp/copyfrom3

real    0m0.020s
user    0m0.000s
sys     0m0.016s
u@u:~$ time cp /media/E0FD-1813/copyto1 /tmp/copyfrom4

real    0m0.022s
user    0m0.000s
sys     0m0.020s
u@u:~$
u@u:~$ ls -lh /tmp/copyfrom*
-rw-r--r-- 1 u u 10M 2011-07-12 10:22 /tmp/copyfrom1
-rw-r--r-- 1 u u 10M 2011-07-12 10:22 /tmp/copyfrom2
-rw-r--r-- 1 u u 10M 2011-07-12 10:22 /tmp/copyfrom3
-rw-r--r-- 1 u u 10M 2011-07-12 10:22 /tmp/copyfrom4
u@u:~$

============ AFTER THE PATCH =============
Sandisk 2GB Class2 SD
==========================================

=== WRITE ===
u@u:~$ time cp ./test.file /media/E0FD-1813/copyto1

real    0m0.757s
user    0m0.000s
sys     0m0.044s
u@u:~$ time cp ./test.file /media/E0FD-1813/copyto2

real    0m0.488s
user    0m0.004s
sys     0m0.020s
u@u:~$ time cp ./test.file /media/E0FD-1813/copyto3

real    0m0.484s
user    0m0.004s
sys     0m0.024s
u@u:~$ time cp ./test.file /media/E0FD-1813/copyto4

real    0m0.486s
user    0m0.000s
sys     0m0.024s
u@u:~$ ls -lh /media/E0FD-1813/
copyto1      copyto2      copyto3      copyto4      .Trash-1001/
u@u:~$ ls -lh /media/E0FD-1813/copyto*
-rw-r--r-- 1 u u 10M 2011-07-12 10:30 /media/E0FD-1813/copyto1
-rw-r--r-- 1 u u 10M 2011-07-12 10:30 /media/E0FD-1813/copyto2
-rw-r--r-- 1 u u 10M 2011-07-12 10:30 /media/E0FD-1813/copyto3
-rw-r--r-- 1 u u 10M 2011-07-12 10:30 /media/E0FD-1813/copyto4
u@u:~$

=== READ ===
u@u:~$ time cp /media/E0FD-1813/copyto1 /tmp/copyfrom1

real    0m0.020s
user    0m0.000s
sys     0m0.016s
u@u:~$ time cp /media/E0FD-1813/copyto1 /tmp/copyfrom2

real    0m0.020s
user    0m0.000s
sys     0m0.016s
u@u:~$ time cp /media/E0FD-1813/copyto1 /tmp/copyfrom3

real    0m0.020s
user    0m0.000s
sys     0m0.016s
u@u:~$ time cp /media/E0FD-1813/copyto1 /tmp/copyfrom4

real    0m0.015s
user    0m0.000s
sys     0m0.012s
u@u:~$ ls -lh /tmp/copyfrom*
-rw-r--r-- 1 u u 10M 2011-07-12 10:31 /tmp/copyfrom1
-rw-r--r-- 1 u u 10M 2011-07-12 10:31 /tmp/copyfrom2
-rw-r--r-- 1 u u 10M 2011-07-12 10:31 /tmp/copyfrom3
-rw-r--r-- 1 u u 10M 2011-07-12 10:31 /tmp/copyfrom4
u@u:~$


====== AFTER THE PATCH - MMC CARD ===========
Transcend MMC 2GB
=============================================

=== WRITE ===
u@u:~$ time cp test.file /media/New\ Volume/copyto1

real    0m0.557s
user    0m0.000s
sys     0m0.024s
u@u:~$ time cp test.file /media/New\ Volume/copyto2

real    0m0.581s
user    0m0.000s
sys     0m0.028s
u@u:~$ time cp test.file /media/New\ Volume/copyto3

real    0m0.581s
user    0m0.000s
sys     0m0.032s
u@u:~$ time cp test.file /media/New\ Volume/copyto4

real    0m0.585s
user    0m0.000s
sys     0m0.028s
u@u:~$ ls -lh /media/New\ Volume/copyto*
-rw-r--r-- 1 u u 10M 2011-07-12 10:42 /media/New Volume/copyto1
-rw-r--r-- 1 u u 10M 2011-07-12 10:42 /media/New Volume/copyto2
-rw-r--r-- 1 u u 10M 2011-07-12 10:42 /media/New Volume/copyto3
-rw-r--r-- 1 u u 10M 2011-07-12 10:42 /media/New Volume/copyto4
u@u:~$

=== READ ===
u@u:~$ time cp /media/New\ Volume/copyto1 /tmp/copyfrom1

real    0m0.154s
user    0m0.000s
sys     0m0.024s
u@u:~$ time cp /media/New\ Volume/copyto1 /tmp/copyfrom2

real    0m0.024s
user    0m0.000s
sys     0m0.020s
u@u:~$ time cp /media/New\ Volume/copyto1 /tmp/copyfrom3

real    0m0.024s
user    0m0.000s
sys     0m0.020s
u@u:~$ time cp /media/New\ Volume/copyto1 /tmp/copyfrom4

real    0m0.022s
user    0m0.000s
sys     0m0.020s
u@u:~$ time cp /media/New\ Volume/copyto2 /tmp/copyfrom5

real    0m0.020s
user    0m0.000s
sys     0m0.016s
u@u:~$ ls -lh /tmp/copyfrom*
-rw-r--r-- 1 u u 10M 2011-07-12 10:44 /tmp/copyfrom1
-rw-r--r-- 1 u u 10M 2011-07-12 10:44 /tmp/copyfrom2
-rw-r--r-- 1 u u 10M 2011-07-12 10:44 /tmp/copyfrom3
-rw-r--r-- 1 u u 10M 2011-07-12 10:44 /tmp/copyfrom4
-rw-r--r-- 1 u u 10M 2011-07-12 10:44 /tmp/copyfrom5
u@u:~$



On Mon, 11 Jul 2011, Chris Ball wrote:

> Hi Manoj, adding linux-mmc@,
>
> On Mon, Jul 11 2011, Manoj Iyer wrote:
>> Ricoh 1180:e823 does not recognize certain types of SD/MMC cards.
>> Lowering the SD base clock frequency from 200Mhz to 50Mhz fixes
>> this issue. This solution was suggest by Koji Matsumuro, Ricoh
>> Company,Ltd.
>>
>> BugLink: http://launchpad.net/bugs/773524
>> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
>> Tested-by: Daniel Manrique <daniel.manrique@canonical.com>
>> Cc: Koji Matsumuro <matsumur@nts.ricoh.co.jp>
>> ---
>>  drivers/pci/quirks.c |   24 ++++++++++++++++++++++++
>>  1 files changed, 24 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index 02145e9..fe5bffa 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -2758,6 +2758,30 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
>>
>>  	dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via firewire function)\n");
>>  	dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI controller\n");
>> +
>> +	/*
>> +	 * RICOH 0xe823 SD/MMC card reader fails to recognize
>> +	 * certain types of SD/MMC cards. Lowering the SD base
>> +	 * clock frequency from 200Mhz to 50Mhz fixes this issue.
>> +	 *
>> +	 * 0x150 - SD2.0 mode enable for changing base clock
>> +	 *	   frequency to 50Mhz
>> +	 * 0xe1  - Base clock frequency
>> +	 * 0x32  - 50Mhz new clock frequency
>> +	 * 0xf9  - Key register for 0x150
>> +	 * 0xfc  - key register for 0xe1
>> +	 */
>> +	if (dev->device == PCI_DEVICE_ID_RICOH_R5CE823) {
>> +		pci_write_config_byte(dev, 0xf9, 0xfc);
>> +		pci_write_config_byte(dev, 0x150, 0x10);
>> +		pci_write_config_byte(dev, 0xf9, 0x00);
>> +		pci_write_config_byte(dev, 0xfc, 0x01);
>> +		pci_write_config_byte(dev, 0xe1, 0x32);
>> +		pci_write_config_byte(dev, 0xfc, 0x00);
>> +
>> +		dev_notice(&dev->dev, "Controller base frequency changed to 50Mhz)\n");
>
> There's an erroneous ")" in this string; I'll replace it with a "." if
> this patch goes in via my tree.  Also, let's make it "MMC controller"
> instead of just "Controller".
>
>> +	}
>> +
>>  }
>>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
>>  DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
>
> Have you checked to see how SD I/O performance differs after this change?
>
> (If this is significant, perhaps we want to try lowering the frequency
> only after a card starts returning errors, since some cards work fine
> at the higher frequency.)
>
> Thanks,
>
> - Chris.
> -- 
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
