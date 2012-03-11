Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2CKRn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 13:43:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48006 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2CKRn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 13:43:28 -0400
MIME-Version: 1.0
Date: Sun, 11 Mar 2012 17:43:26 +0000
Message-ID: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
Subject: Initializing iwl3945 error
From: Kamil Grzebien <ciptok@gmail.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've initialisation problem with my iwl3945 network card in Dell XPS
M1530 laptop. The issue is known and described in couple of bug
reports (eg. http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2143).
There are workarounds but I'd like to solve the problem permanently.
Basically when initializing I get:

iwl3945 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
iwl3945 0000:0b:00.0: setting latency timer to 64
iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
....
iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:0b:00.0: bad EEPROM signature,EEPROM_GP=0x00000007
iwl3945 0000:0b:00.0: EEPROM not found, EEPROM_GP=0xffffffff

Currently I'm working on Fedora 16 with 3.1.5-6.fc16.i686 kernel. I
did some investigation/debugging on iwlegacy driver and found out few
things.

1. Driver can't initialize card as all ioread32/iowrite32 seems to not
do their job. All reads finalize with 0xffffffff.

However I can see that:
- pci_iomap(pdev, 0, 0) doesn't return error,
- pci_resource_start(pdev, 0) seems gives correct address (I can
compare it with the one I can see in /proc/iomem).

If I access the memory directly, not by mapping, I can write and read
pci memory but driver load fails anyway. I don't understand why can't
access using mapped memory.

2. If I check BASE_ADDRESS with setpci it doesn't give correct values:

# setpci -v -s 0b:00.0 BASE_ADDRESS_0 BASE_ADDRESS_1
0000:0b:00.0 @10 = 00000000
0000:0b:00.0 @14 = 00000000

Not sure if it's done by driver itself or it should point correct
values even if the driver wasn't fully loaded.

Have you got any idea of:
- why IO memory isn't accessible? what could cause that?
- how APIC could change the load process in this particular case? (if
I boot with noapic kernel option it usually works fine)
- is there a way to check the status or rescan the device from driver itself?

This issue is reproducible in 100% on my system when I turn on the
machine. It doesn't occur after some work on it. I'd be very happy to
get rid of the issue.

Could you point some ideas that might be worth checking in driver or
kernel please? I've tried couple of ideas but none worked for me.

Regards,
Kamil Grzebien
