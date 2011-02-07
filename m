Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1BGBu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 20:50:59 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1116 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754343Ab1BGBuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 20:50:40 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23313
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 07/09] ARM: s3c2440: gta02: Call regulator_has_full_constraints
Date: Mon,  7 Feb 2011 02:51:59 +0100
Message-Id: <1297043521-21903-7-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297043521-21903-1-git-send-email-lars@metafoo.de>
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the end of gta02_pmu_attach_child_devices all drivers should have taken
control of their regulators and we can tell the regulator core to disable all
regulators which are currently not in use.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/arm/mach-s3c2440/mach-gta02.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index 01e0930..1396639 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -563,6 +563,8 @@ static void gta02_pmu_attach_child_devices(struct pcf50633 *pcf)
 
 	platform_add_devices(gta02_devices_pmu_children,
 			     ARRAY_SIZE(gta02_devices_pmu_children));
+
+	regulator_has_full_constraints();
 }
 
 static void gta02_poweroff(void)
-- 
1.7.2.3

