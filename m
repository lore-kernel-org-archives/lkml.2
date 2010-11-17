Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734Ab0KQPIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:08:04 -0500
Received: from usindmx01.hds.com ([207.126.252.12]:56104 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab0KQPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:08:01 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        ext KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "marco.stornelli@gmail.com" <marco.stornelli@gmail.com>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        Aaron Durbin <adurbin@google.com>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Wed, 17 Nov 2010 10:00:37 -0500
Subject: [PATCH 1/2] kmsg_dump: adding to reboot, halt, poweroff and
 emergency_restart path
Thread-Topic: [PATCH 1/2] kmsg_dump: adding to reboot, halt, poweroff and
 emergency_restart path
Thread-Index: AcuGZI2/m1RrdnFLRB6WCVKdkLnjOgAADLkQAADI5ZA=
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2FA@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2F5@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2F5@USINDEVS01.corp.hds.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAHF8SIF004495

This patch alters mtdoops and ramoops to perform their actions only for KMSG_DUMP_PANIC,
KMSG_DUMP_OOPS and KMSG_DUMP_KEXEC because they would like to log crashes only.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 drivers/char/ramoops.c |    5 +++++
 drivers/mtd/mtdoops.c  |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c index 73dcb0e..8998b29 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -69,6 +69,11 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	char *buf;
 	struct timeval timestamp;
 
+	if (reason != KMSG_DUMP_OOPS &&
+	    reason != KMSG_DUMP_PANIC &&
+	    reason != KMSG_DUMP_KEXEC)
+		return;
+
 	/* Only dump oopses if dump_oops is set */
 	if (reason == KMSG_DUMP_OOPS && !dump_oops)
 		return;
diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c index 1ee72f3..c948150 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -307,6 +307,11 @@ static void mtdoops_do_dump(struct kmsg_dumper *dumper,
 	unsigned long l1_cpy, l2_cpy;
 	char *dst;
 
+	if (reason != KMSG_DUMP_OOPS &&
+	    reason != KMSG_DUMP_PANIC &&
+	    reason != KMSG_DUMP_KEXEC)
+		return;
+
 	/* Only dump oopses if dump_oops is set */
 	if (reason == KMSG_DUMP_OOPS && !dump_oops)
 		return;
--
1.7.2.2

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
