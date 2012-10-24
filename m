Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab2JXNuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:50:18 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:49008 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab2JXNuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:50:16 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Adding SATA support for Armada 370/XP
Date: Wed, 24 Oct 2012 15:49:19 +0200
Message-Id: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this small patch set adds the SATA support for Armada 370 and Armada XP.

The evaluation boards for Armada 370 and Armada XP come with 2 SATA
ports, and when both are enable the coherent pool for DMA mapping was
too short. It was exactly the same issue that was fixed for Kirkwood
two months ago. So I used the same fix in the first patch. Later when
Kirkwood will be part of mach-mvebu, then this fix will be shared
between the 2 SoCs families.

This patch set is based on 3.7-rc2 and depends one the framework clock
support (the last version was posted last week:
http://thread.gmane.org/gmane.linux.kernel/1375701). The git branch
called mvebu-SATA-for-3.8 is also available at
https://github.com/MISL-EBU-System-SW/mainline-public.git.

Regards,

Gregory

Gregory CLEMENT (1):
  arm: mvebu: increase atomic coherent pool size for armada 370/XP

Lior Amsalem (1):
  arm: mvebu: adding SATA support: dt binding and config update

 arch/arm/boot/dts/armada-370-db.dts  |    3 +++
 arch/arm/boot/dts/armada-370-xp.dtsi |   10 ++++++++++
 arch/arm/boot/dts/armada-xp-db.dts   |    3 +++
 arch/arm/configs/mvebu_defconfig     |    7 +++++++
 arch/arm/mach-mvebu/armada-370-xp.c  |   12 ++++++++++++
 5 files changed, 35 insertions(+)

-- 
1.7.9.5

