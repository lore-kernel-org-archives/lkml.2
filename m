Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab2KZRKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:10:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47754 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365Ab2KZRJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:58 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 161/270] hwmon: (coretemp) Add support for Atom CE4110/4150/4170
Date: Mon, 26 Nov 2012 14:57:31 -0200
Message-Id: <1353949160-26803-162-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 1102dcab849313bd5a340b299b5cf61b518fbc0f upstream.

TjMax for the CE4100 series of Atom CPUs was previously reported to be
110 degrees C.

cpuinfo logs on the web show existing CPU types CE4110, CE4150, and CE4170,
reported as "model name : Intel(R) Atom(TM) CPU CE41{1|5|7}0 @ 1.{2|6}0GHz"
with model 28 (0x1c) and stepping 10 (0x0a). Add the three known variants
to the tjmax table.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 Documentation/hwmon/coretemp |    1 +
 drivers/hwmon/coretemp.c     |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/hwmon/coretemp b/Documentation/hwmon/coretemp
index c86b50c..f17256f 100644
--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -105,6 +105,7 @@ Process		Processor					TjMax(C)
 		330/230						125
 		E680/660/640/620				90
 		E680T/660T/640T/620T				110
+		CE4170/4150/4110				110
 
 45nm		Core2 Processors
 		Solo ULV SU3500/3300				100
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 637c51c..fba26ee 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -205,8 +205,11 @@ static struct tjmax __cpuinitconst tjmax_table[] = {
 	{ "CPU N455", 100000 },
 	{ "CPU N470", 100000 },
 	{ "CPU N475", 100000 },
-	{ "CPU  230", 100000 },
-	{ "CPU  330", 125000 },
+	{ "CPU  230", 100000 },		/* Model 0x1c, stepping 2	*/
+	{ "CPU  330", 125000 },		/* Model 0x1c, stepping 2	*/
+	{ "CPU CE4110", 110000 },	/* Model 0x1c, stepping 10	*/
+	{ "CPU CE4150", 110000 },	/* Model 0x1c, stepping 10	*/
+	{ "CPU CE4170", 110000 },	/* Model 0x1c, stepping 10	*/
 };
 
 static int __cpuinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id,
-- 
1.7.9.5

