Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab1HKNxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:53:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46086 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab1HKNxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:53:11 -0400
Date: Thu, 21 Aug 2011 18:22:10 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: Matthew Garrett <mjg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>,
        Michel Alexandre Salim <salimma@fedoraproject.org>,
        intel-gfx@lists.freedesktop.org, Ali Gholami Rudi <aliqrudi@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: missing acpi backlight bisected to 9661e92c10
Message-ID: <20112108181410@lilem.mirepesht>
In-Reply-To: <20110811123929.GA22409@srcf.ucam.org>
References: <1312829662.3379.138.camel@fourier>
 <yunliv38ugd.fsf@aiko.keithp.com>
 <20110808213140.GA32504@srcf.ucam.org>
 <yunfwlb8qy4.fsf@aiko.keithp.com>
 <4E428421.1000605@fedoraproject.org>
 <yunipq5gvxd.fsf@aiko.keithp.com>
 <20110810191700.81c3a7ee.akpm@linux-foundation.org>
 <20112108083014@lilem.mirepesht>
 <20112108160718@lilem.mirepesht>
	<20110811123929.GA22409@srcf.ucam.org>
User-Agent: git://repo.or.cz/mailx.git
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> wrote:
> Sigh. Could you provide the output of lspci and acpidump?

acpidump: https://bugzilla.kernel.org/attachment.cgi?id=24674

$ lspci
00:00.0 Host bridge: Intel Corporation Mobile GME965/GLE960 Memory Controller Hub (rev 0c)
00:02.0 VGA compatible controller: Intel Corporation Mobile GME965/GLE960 Integrated Graphics Controller (rev 0c)
00:02.1 Display controller: Intel Corporation Mobile GME965/GLE960 Integrated Graphics Controller (rev 0c)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03)
30:00.0 Ethernet controller: Marvell Technology Group Ltd. Device 4357 (rev 10)

I don't know much about ACPI, but is acpidump's output supposed to
change?  The above dump has been taken almost a year ago (for
another ACPI bug) and now that I compare it with my current dump, I
get:

--- acpidump1	2011-08-11 18:16:37.509899444 +0430
+++ acpidump2	2011-08-11 18:03:33.778749912 +0430
@@ -5143,24 +5143,6 @@
   0060: 00 00 00 00 88 c4 7d 3f 00 00 00 00 2e c5 7d 3f  ......}?......}?
   0070: 00 00 00 00                                      ....
 
-FACP @ 0x3f7c8000
-  0000: 46 41 43 50 84 00 00 00 02 ff 48 50 20 20 20 20  FACP......HP    
-  0010: 33 30 38 41 20 20 20 20 02 00 00 00 48 50 20 20  308A    ....HP  
-  0020: 01 00 00 00 80 7d 7e 3f 48 83 7c 3f 00 00 09 00  .....}~?H.|?....
-  0030: b2 00 00 00 f1 f0 f2 80 00 10 00 00 00 00 00 00  ................
-  0040: 04 10 00 00 00 00 00 00 20 10 00 00 08 10 00 00  ........ .......
-  0050: 28 10 00 00 00 00 00 00 04 02 01 04 08 00 00 00  (...............
-  0060: 02 00 87 00 00 00 00 00 01 03 0d 00 32 13 00 00  ............2...
-  0070: a5 80 00 00 01 08 00 00 00 00 00 00 00 00 00 00  ................
-  0080: 00 00 00 00                                      ....
-
-RSDT @ 0x3f7c8178
-  0000: 52 53 44 54 4c 00 00 00 01 68 48 50 20 20 20 20  RSDTL....hHP    
-  0010: 33 30 38 41 20 20 20 20 20 09 07 28 48 50 20 20  308A     ..(HP  
-  0020: 01 00 00 00 00 80 7c 3f 38 82 7c 3f 70 82 7c 3f  ......|?8.|?p.|?
-  0030: d8 82 7c 3f 14 83 7c 3f 9f b3 7d 3f c7 b6 7d 3f  ..|?..|?..}?..}?
-  0040: 29 c2 7d 3f 88 c4 7d 3f 2e c5 7d 3f              ).}?..}?..}?
-
 RSD PTR @ 0xf6f60
   0000: 52 53 44 20 50 54 52 20 13 48 50 20 20 20 20 02  RSD PTR .HP    .
   0010: 78 81 7c 3f 24 00 00 00 c4 81 7c 3f 00 00 00 00  x.|?$.....|?....

	Ali

