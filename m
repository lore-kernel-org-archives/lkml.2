Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1GOTEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 15:04:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab1GOTEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 15:04:37 -0400
Message-ID: <4E208F59.7070003@tech-chat.de>
Date: Fri, 15 Jul 2011 21:04:57 +0200
From: Andreas Weber <spam@tech-chat.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: spam@tech-chat.de
Subject: sporadic oops and freeze when booting 2.6.39-2-amd64 on debian wheezy
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:z7sr3mFr9lq//mH0C/601kLPOfrB4iiOGqUbt0+IWvT
 mQ0PpjhI/kDCIGEI9IhI+81GQF4A9G8KyfMI6JdQTfSpWehsX4
 k9H4Yjdyulvzlzl7OI3TxksOzXlTpFKSSRpwsU5CGwrdLUFamw
 VCX1TMd9JcXUA1hWhzXErzW95LZwVyNVVEC9tb1WPC1wPySLyA
 H6nLk35FZztUM6x7OXNrpJdxXZTub9AoFlI8GzabDA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel mailing list,

the boot process freezes sometimes(average once from 15 boots) since
2.6.39-2-amd64.

I have uploaded a kernel.log when the boot process freezes:
http://www.tech-chat.de/files/kern_failed.log

After waiting 15min I made a hard reset and this time the computer
booted successfully:
http://www.tech-chat.de/files/kern_working.log

I have cropped the date and made a diff with
awk 'BEGIN{FS="]"}{$1="";print $0}' kern_failed.log >
kern_failed_without_time.log
awk 'BEGIN{FS="]"}{$1="";print $0}' kern_working.log >
kern_working_without_time.log
diff -uN kern_failed_without_time.log kern_working_without_time.log>
diff.log

http://www.tech-chat.de/files/diff.log

Here some interessting parts from the diff.log
...
  BIOS-e820: 00000000cfea8000 - 00000000cfed0000 (ACPI NVS)
  BIOS-e820: 00000000cfed0000 - 00000000cff00000 (reserved)
  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
- BIOS-e820: 0000000100000000 - 00000001a0000000 (usable)
+ BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
...
-last_pfn = 0x1a0000 max_arch_pfn = 0x400000000
+last_pfn = 0x220000 max_arch_pfn = 0x400000000
...
-TOM2: 00000001b0000000 aka 6912M
+TOM2: 0000000230000000 aka 8960M
...
-  Normal zone: 8960 pages used for memmap
-  Normal zone: 646400 pages, LIFO batch:31
+  Normal zone: 16128 pages used for memmap
+  Normal zone: 1163520 pages, LIFO batch:31
...
-  IP: [<ffffffff81042b3d>  load_balance+0x5e4/0x688
-  PGD 1605067 PUD 0
-  Oops: 0000 [#1  SMP
-  last sysfs file: /sys/module/crc_itu_t/initstate
-  CPU 3
--
-  IP: [<ffffffff81042b3d>  load_balance+0x5e4/0x688
-  PGD 1605067 PUD 0
-  Oops: 0000 [#2  SMP
-  last sysfs file: /sys/module/nfsd/initstate
-  CPU 0
...

I think the BIOS reports sometimes bogus data?
The motherboard is a Asus M4A89GTD-PRO/USB3 with BIOS 2101
(http://www.asus.com/Motherboards/AMD_AM3/M4A89GTD_PROUSB3/#download)


This all leads finally to:

Jul 13 17:02:01 PhenomBabe kernel: [   13.137385] BUG: unable to handle
kernel paging request at ffffffff0a646ecf
Jul 13 17:02:01 PhenomBabe kernel: [   13.141181] IP:
[<ffffffff81042b3d>] load_balance+0x5e4/0x688
Jul 13 17:02:01 PhenomBabe kernel: [   13.141181] PGD 1605067 PUD 0
Jul 13 17:02:01 PhenomBabe kernel: [   13.141181] Oops: 0000 [#2] SMP

Any hints on that or may I provide further data?

Please add me to CC if possible.

Thank you very much,
best regards Andy
