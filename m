Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2L1TQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:16:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54878 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754211Ab2L1TQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:52 -0500
Message-Id: <20121228190333.183112406@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Subject: [ 015/173] hwmon: (coretemp) Add support for Atom CE4110/4150/4170
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/hwmon/coretemp |    1 +
 drivers/hwmon/coretemp.c     |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -94,6 +94,7 @@ Process		Processor					TjMax(C)
 		330/230						125
 		E680/660/640/620				90
 		E680T/660T/640T/620T				110
+		CE4170/4150/4110				110
 
 45nm		Core2 Processors
 		Solo ULV SU3500/3300				100
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -204,8 +204,11 @@ static struct tjmax __cpuinitconst tjmax
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
 
 static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)


