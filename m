Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab1CIRFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:05:44 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:55678 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438Ab1CIRFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:05:41 -0500
From: Maxime Coquelin <maxime.coquelin-nonst@stericsson.com>
To: LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: <maxime_coquelin@yahoo.fr>, ext Nishanth Menon <nm@ti.com>,
        ext Tony Lindgren <tony@atomide.com>,
        Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
        Ambresh <a0393775@ti.com>, Jouni Hogander <jouni.hogander@nokia.com>,
        Lee Jones <Lee.Jones@linaro.org>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        David Brown <davidb@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Andrei Warkentin <andreiw@motorola.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maxime Coquelin <maxime.coquelin-nonst@stericsson.com>
Subject: [RFC PATCHv1 0/2] Export SoC info through sysfs
Date: Wed, 9 Mar 2011 17:59:19 +0100
Message-ID: <1299689961-5028-1-git-send-email-maxime.coquelin-nonst@stericsson.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the first version of the proposal to export SoC related information to user-space through sysFS interface.

This serie is to continue what has been discussed on the "socinfo" thread created by Eduardo Valentin:
https://lkml.org/lkml/2010/5/11/364

The first patch introduces the common part, which provides an interface to the platform to register its name, and exports platform-defined IDs to user-space.
The IDs strings can be provided in two ways: either with a pointer to the string, or by a callback returning the string.

The second patch is given as example for the ux500 architecture. It registers with the machine name "DB8500", and exports 3 informations (SoC unique ID, sili
con revision and silicon process).

Here is the output for DB8500:
root@ME:/sys/devices/system/soc ls -l
-r--r--r--    1 root     root         4096 Jan 11 02:43 mach_name
-r--r--r--    1 root     root         4096 Jan 11 02:43 process
-r--r--r--    1 root     root         4096 Jan 11 02:43 revision
-r--r--r--    1 root     root         4096 Jan 11 02:43 soc_id
root@ME:/sys/devices/system/soc cat mach_name
DB8500
root@ME:/sys/devices/system/soc cat process
Standard
root@ME:/sys/devices/system/soc cat revision
2.0
root@ME:/sys/devices/system/soc cat soc_id
2ba07ce9e5835d6185321e9577462ef2ea2129cf

Any comments are welcome.

Note that I will be off from 13th to 21th of March.

Regards,
Maxime

-------------------------------------------------------------------------------

Maxime Coquelin (2):
  Export SoC info through sysfs
  ux500: Export U8500 SoC info through sysfs

 arch/arm/mach-ux500/id.c |   96 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/base/Kconfig     |    4 ++
 drivers/base/Makefile    |    1 +
 drivers/base/soc.c       |   88 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/sys_soc.h  |   33 ++++++++++++++++
 5 files changed, 222 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/soc.c
 create mode 100644 include/linux/sys_soc.h

