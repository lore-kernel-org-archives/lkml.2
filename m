Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1CKMln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:41:43 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:40637 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754694Ab1CKMlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:41:31 -0500
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
Subject: [RFC PATCHv2 0/2] Export SoC info through sysfs
Date: Fri, 11 Mar 2011 13:35:09 +0100
Message-ID: <1299846911-15782-1-git-send-email-maxime.coquelin-nonst@stericsson.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the second version of the proposal to export SoC related information to user-space through sysFS interface.

The first patch introduces the common part, which provides an interface to the platform to export platform-defined IDs to user-space.
The IDs strings can be provided in two ways: either with a pointer to the string, or by a callback fullfilling the sysfs's "show" callback buffer.

The second patch is given as example for the ux500 architecture. It registers the socinfo interface, and exports 5 values (Family name, machine name, silicon process, silicon revision, and serial number).

Here is the output for DB8500:
root@ME:/sys/socinfo ls -l
-r--r--r-- 1 root root 4096 Jan  2 03:35 family
-r--r--r-- 1 root root 4096 Jan  2 03:35 machine
-r--r--r-- 1 root root 4096 Jan  2 03:35 process
-r--r--r-- 1 root root 4096 Jan  2 03:35 revision
-r--r--r-- 1 root root 4096 Jan  2 03:35 soc_id
root@ME:/sys/socinfo cat machine
DB8500
root@ME:/sys/socinfo cat family
Ux500
root@ME:/sys/socinfo cat process
Standard
root@ME:/sys/socinfo cat revision
2.0
root@ME:/sys/socinfo cat soc_id
2ba07ce9e5835d6185321e9577462ef2ea2129cf

-------------------------------------------------------------------------------
v1:
	Conclusion about first version :
		* /sys/devices/system is not right place for this interface.
		* "mach_name" should be declared as other attributes to simplify code.
		* The get_info callback should use directly the "show" callback buffer.
		* Documentation was missing (ABI description required)
		* Errors were not reported at registration time.
		* Macros should be used to create attributes.
		* Some kernel coding rules not followed.

-------------------------------------------------------------------------------

Any comments are welcome.

Note that I will be off from 13th to 21th of March.

Regards,
Maxime

-------------------------------------------------------------------------------

Maxime Coquelin (2):
  Export SoC info through sysfs
  ux500: Export U8500 SoC info through sysfs

 Documentation/ABI/testing/sysfs-socinfo |   16 ++++++
 arch/arm/mach-ux500/Kconfig             |    1 +
 arch/arm/mach-ux500/id.c                |   70 +++++++++++++++++++++++++++
 drivers/base/Kconfig                    |    3 +
 drivers/base/Makefile                   |    1 +
 drivers/base/soc.c                      |   79 +++++++++++++++++++++++++++++++
 include/linux/sys_soc.h                 |   50 +++++++++++++++++++
 7 files changed, 220 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-socinfo
 create mode 100644 drivers/base/soc.c
 create mode 100644 include/linux/sys_soc.h

