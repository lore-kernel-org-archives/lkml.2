Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1GGPZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:25:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42019 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1GGPZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:25:19 -0400
MIME-Version: 1.0
Date: Thu, 7 Jul 2011 17:25:19 +0200
Message-ID: <CACna6rxAKMp-2wqwz4k4S3nTkY_3Qz7=hEZk9F2Zig7T5kp_HA@mail.gmail.com>
Subject: Bug in BCMA: device_unregister causing "NULL pointer dereference at"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've problem with bcma and bus subsystem.

This works fine:
modprobe bcma; rmmod bcma

This:
modprobe bcma; modprobe b43; rmmod b43; rmmod bcma
causes:
BUG: unable to handle kernel NULL pointer dereference at   (null)

My BCMA has only 3 fores, out of them only 1 is registered as device:
bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)

The dereference comes out from
static void bcma_unregister_cores(struct bcma_bus *bus)

There is a simple loop:
list_for_each_entry(core, &bus->cores, list) {
	if (core->dev_registered)
		device_unregister(&core->dev);
}


So when I unload bcma after I got driver (b43) for 0x812 core, I get
NULL pointer dereference.

Any tip, why does it happen?

-- 
Rafał
