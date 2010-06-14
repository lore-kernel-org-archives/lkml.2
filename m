Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab0FNVpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:45:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43784 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab0FNVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:44:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 14 Jun 2010 23:44:42 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: remove unused code
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <1276547208-26569-8-git-send-email-justinmattock@gmail.com>
Message-ID: <tkrat.6f2ad8e8a9e281c2@s5r6.in-berlin.de>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
 <1276547208-26569-8-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

which caused gcc 4.6 to warn about
    variable 'unit_characteristics' set but not used.

The underlying problem that was spotted here --- an incomplete
implementation --- is already 50% fixed in drivers/firewire/sbp2.c which
observes mgt_ORB_timeout but not yet ORB_size.

Reported-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: b/drivers/ieee1394/sbp2.c
===================================================================
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1350,12 +1350,11 @@ static void sbp2_parse_unit_directory(st
 	struct csr1212_keyval *kv;
 	struct csr1212_dentry *dentry;
 	u64 management_agent_addr;
-	u32 unit_characteristics, firmware_revision, model;
+	u32 firmware_revision, model;
 	unsigned workarounds;
 	int i;
 
 	management_agent_addr = 0;
-	unit_characteristics = 0;
 	firmware_revision = SBP2_ROM_VALUE_MISSING;
 	model = ud->flags & UNIT_DIRECTORY_MODEL_ID ?
 				ud->model_id : SBP2_ROM_VALUE_MISSING;
@@ -1372,17 +1371,15 @@ static void sbp2_parse_unit_directory(st
 				lu->lun = ORB_SET_LUN(kv->value.immediate);
 			break;
 
-		case SBP2_UNIT_CHARACTERISTICS_KEY:
-			/* FIXME: This is ignored so far.
-			 * See SBP-2 clause 7.4.8. */
-			unit_characteristics = kv->value.immediate;
-			break;
 
 		case SBP2_FIRMWARE_REVISION_KEY:
 			firmware_revision = kv->value.immediate;
 			break;
 
 		default:
+			/* FIXME: Check for SBP2_UNIT_CHARACTERISTICS_KEY
+			 * mgt_ORB_timeout and ORB_size, SBP-2 clause 7.4.8. */
+
 			/* FIXME: Check for SBP2_DEVICE_TYPE_AND_LUN_KEY.
 			 * Its "ordered" bit has consequences for command ORB
 			 * list handling. See SBP-2 clauses 4.6, 7.4.11, 10.2 */

-- 
Stefan Richter
-=====-==-=- -==- -===-
http://arcgraph.de/sr/

