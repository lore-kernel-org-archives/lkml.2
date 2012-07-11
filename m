Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab2GKA02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:26:28 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:5660 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213Ab2GKA00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:26:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1341966373!3692468!5
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 82/83] staging: comedi: rtd520: cleanup the range tables
Date: Tue, 10 Jul 2012 17:26:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101726.05244.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the whitespace of the range tables to avoid the > 80
character lines and the ugly line breaks. Convert a couple of
the RANGE() values into the appropriate {UNI,BIP}_RANGE().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 154 +++++++++++++-------------------
 1 file changed, 63 insertions(+), 91 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 9a29500..102e635 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -194,103 +194,75 @@ Configuration options:
 ======================================================================*/
 
 /*
-  The board has 3 input modes and the gains of 1,2,4,...32 (, 64, 128)
-*/
-static const struct comedi_lrange rtd_ai_7520_range = { 18, {
-							     /* +-5V input range gain steps */
-							     BIP_RANGE(5.0),
-							     BIP_RANGE(5.0 / 2),
-							     BIP_RANGE(5.0 / 4),
-							     BIP_RANGE(5.0 / 8),
-							     BIP_RANGE(5.0 /
-								       16),
-							     BIP_RANGE(5.0 /
-								       32),
-							     /* +-10V input range gain steps */
-							     BIP_RANGE(10.0),
-							     BIP_RANGE(10.0 /
-								       2),
-							     BIP_RANGE(10.0 /
-								       4),
-							     BIP_RANGE(10.0 /
-								       8),
-							     BIP_RANGE(10.0 /
-								       16),
-							     BIP_RANGE(10.0 /
-								       32),
-							     /* +10V input range gain steps */
-							     UNI_RANGE(10.0),
-							     UNI_RANGE(10.0 /
-								       2),
-							     UNI_RANGE(10.0 /
-								       4),
-							     UNI_RANGE(10.0 /
-								       8),
-							     UNI_RANGE(10.0 /
-								       16),
-							     UNI_RANGE(10.0 /
-								       32),
-
-							     }
+ * The board has 3 input modes and the gains of 1,2,4,...32 (, 64, 128)
+ */
+static const struct comedi_lrange rtd_ai_7520_range = {
+	18, {
+		/* +-5V input range gain steps */
+		BIP_RANGE(5.0),
+		BIP_RANGE(5.0 / 2),
+		BIP_RANGE(5.0 / 4),
+		BIP_RANGE(5.0 / 8),
+		BIP_RANGE(5.0 / 16),
+		BIP_RANGE(5.0 / 32),
+		/* +-10V input range gain steps */
+		BIP_RANGE(10.0),
+		BIP_RANGE(10.0 / 2),
+		BIP_RANGE(10.0 / 4),
+		BIP_RANGE(10.0 / 8),
+		BIP_RANGE(10.0 / 16),
+		BIP_RANGE(10.0 / 32),
+		/* +10V input range gain steps */
+		UNI_RANGE(10.0),
+		UNI_RANGE(10.0 / 2),
+		UNI_RANGE(10.0 / 4),
+		UNI_RANGE(10.0 / 8),
+		UNI_RANGE(10.0 / 16),
+		UNI_RANGE(10.0 / 32),
+	}
 };
 
 /* PCI4520 has two more gains (6 more entries) */
-static const struct comedi_lrange rtd_ai_4520_range = { 24, {
-							     /* +-5V input range gain steps */
-							     BIP_RANGE(5.0),
-							     BIP_RANGE(5.0 / 2),
-							     BIP_RANGE(5.0 / 4),
-							     BIP_RANGE(5.0 / 8),
-							     BIP_RANGE(5.0 /
-								       16),
-							     BIP_RANGE(5.0 /
-								       32),
-							     BIP_RANGE(5.0 /
-								       64),
-							     BIP_RANGE(5.0 /
-								       128),
-							     /* +-10V input range gain steps */
-							     BIP_RANGE(10.0),
-							     BIP_RANGE(10.0 /
-								       2),
-							     BIP_RANGE(10.0 /
-								       4),
-							     BIP_RANGE(10.0 /
-								       8),
-							     BIP_RANGE(10.0 /
-								       16),
-							     BIP_RANGE(10.0 /
-								       32),
-							     BIP_RANGE(10.0 /
-								       64),
-							     BIP_RANGE(10.0 /
-								       128),
-							     /* +10V input range gain steps */
-							     UNI_RANGE(10.0),
-							     UNI_RANGE(10.0 /
-								       2),
-							     UNI_RANGE(10.0 /
-								       4),
-							     UNI_RANGE(10.0 /
-								       8),
-							     UNI_RANGE(10.0 /
-								       16),
-							     UNI_RANGE(10.0 /
-								       32),
-							     UNI_RANGE(10.0 /
-								       64),
-							     UNI_RANGE(10.0 /
-								       128),
-							     }
+static const struct comedi_lrange rtd_ai_4520_range = {
+	24, {
+		/* +-5V input range gain steps */
+		BIP_RANGE(5.0),
+		BIP_RANGE(5.0 / 2),
+		BIP_RANGE(5.0 / 4),
+		BIP_RANGE(5.0 / 8),
+		BIP_RANGE(5.0 / 16),
+		BIP_RANGE(5.0 / 32),
+		BIP_RANGE(5.0 / 64),
+		BIP_RANGE(5.0 / 128),
+		/* +-10V input range gain steps */
+		BIP_RANGE(10.0),
+		BIP_RANGE(10.0 / 2),
+		BIP_RANGE(10.0 / 4),
+		BIP_RANGE(10.0 / 8),
+		BIP_RANGE(10.0 / 16),
+		BIP_RANGE(10.0 / 32),
+		BIP_RANGE(10.0 / 64),
+		BIP_RANGE(10.0 / 128),
+		/* +10V input range gain steps */
+		UNI_RANGE(10.0),
+		UNI_RANGE(10.0 / 2),
+		UNI_RANGE(10.0 / 4),
+		UNI_RANGE(10.0 / 8),
+		UNI_RANGE(10.0 / 16),
+		UNI_RANGE(10.0 / 32),
+		UNI_RANGE(10.0 / 64),
+		UNI_RANGE(10.0 / 128),
+	}
 };
 
 /* Table order matches range values */
-static const struct comedi_lrange rtd_ao_range = { 4, {
-						       RANGE(0, 5),
-						       RANGE(0, 10),
-						       RANGE(-5, 5),
-						       RANGE(-10, 10),
-						       }
+static const struct comedi_lrange rtd_ao_range = {
+	4, {
+		UNI_RANGE(5),
+		UNI_RANGE(10),
+		BIP_RANGE(5),
+		BIP_RANGE(10),
+	}
 };
 
 /*
-- 
1.7.11

