Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab1BDWjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:39:39 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:33000 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1BDWji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:39:38 -0500
Date: Fri, 4 Feb 2011 17:38:59 -0500 (EST)
From: Tony Camuso <tcamuso@redhat.com>
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>,
        Thomas Mingarelli <thomas.mingarelli@hp.com>
Message-ID: <897313439.248768.1296859139219.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: [PATCH 1/1] drivers/watchdog: build hpwdt as module by default with
 NMI_DECODING enabled
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DESCRIPTION
===========
Builds the hpwdt driver as a module by default.
If the hardware is present, the module will be loaded.
Also, if hpwdt is loaded, it will decode NMIs by default.

This has been made possible by he patches to hpwdt made by Dann Frazier
as well as related patches submitted by Don Zickus.

hpwdt only loads on hp ProLiant x86 32-bit and 64-bit platforms.

TESTING
=======
Was tested for functionality and regression. Was built against i686,
x86_64, ppc, ppc64, s390x, and noarch with no problems.

DIFF STAT
=========
 drivers/watchdog/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

	Signed-off-by: Tony Camuso <tcamuso@redhat.com>

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 7a8a813..df3ca2e 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -523,6 +523,7 @@ config IT87_WDT
 config HP_WATCHDOG
 	tristate "HP Proliant iLO2+ Hardware Watchdog Timer"
 	depends on X86
+	default m
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
 	  will detect lockups and provide a stack trace. This is a driver that
@@ -533,6 +534,7 @@ config HP_WATCHDOG
 config HPWDT_NMI_DECODING
 	bool "NMI decoding support for the HP ProLiant iLO2+ Hardware Watchdog Timer"
 	depends on HP_WATCHDOG
+	default y
 	help
 	  When an NMI occurs this feature will make the necessary BIOS calls to
 	  log the cause of the NMI.
