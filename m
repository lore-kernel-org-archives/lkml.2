Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab2K0Aud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:50:33 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:62967 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab2K0Auc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:50:32 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "=?iso-8859-1?Q?'Bruno_Pr=E9mont'?=" <bonbons@linux-vserver.org>
Cc: <support@Supermicro.com>, <linux-kernel@vger.kernel.org>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com> <20121126224245.248f0901@neptune.home>
In-Reply-To: <20121126224245.248f0901@neptune.home>
Subject: RE: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware bug question
Date: Mon, 26 Nov 2012 19:50:30 -0500
Message-ID: <002901cdcc39$33ae8550$9b0b8ff0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH421ylXKr/7aSEd56ctRShmAJ9gwGHtGctl5pegPA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> [    0.696357] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    0.696487] ioatdma 0000:00:04.0: channel error register unreachable
> I assume this is something Supermicro has to fix?

You are probably missing some kernel config option(s) :) - I did fight
similar
issues on a Fujitsu SandyBridge Xeon based server.

Check if enabling CONFIG_X86_X2APIC helps as well as other APIC/IOMMU
options.

Bruno

=> Enabled:
CONFIG_IOMMU_SUPPORT
CONFIG_INTEL_IOMMU
CONFIG_INTEL_IOMMU_DEFAULT_ON
CONFIG_IRQ_REMAP

Also tried enabling NUMA, etc:

[    0.330998] ACPI FADT declares the system doesn't support PCIe ASPM, so
disable it
[    0.331068] ACPI: bus type pci registered

[    0.615234] ACPI: Dynamic OEM Table Load:
[    0.615373] ACPI: PRAD           (null) 000BE (v02 PRADID  PRADTID
00000001 MSFT 04000000)
[    0.615631] \_SB_:_OSC invalid UUID
[    0.615633] _OSC request data:1 7


[    0.663138] pci 0000:ff:13.5: [8086:3c44] type 00 class 0x110100
[    0.663170] pci 0000:ff:13.6: [8086:3c45] type 00 class 0x088000
[    0.663211]  pci0000:ff: ACPI _OSC support notification failed, disabling
PCIe ASPM
[    0.663281]  pci0000:ff: Unable to request _OSC control (_OSC support
mask: 0x08)

:(

Justin.



