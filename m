Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2ECACN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:02:13 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:20375 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2ECACM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:02:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1336003331!4569536!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] w1: w1_ds2408.c: quite sparse noise about using plaing integer as NULL pointer
Date: Wed, 2 May 2012 17:02:07 -0700
User-Agent: KMail/1.9.9
CC: <zbr@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205021702.07694.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NULL not 0 should be used with pointers. Just remove the offending
lines since they will default to NULL anyway.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>

---

diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
index 7c8cdb8..8e813ee 100644
--- a/drivers/w1/slaves/w1_ds2408.c
+++ b/drivers/w1/slaves/w1_ds2408.c
@@ -332,7 +332,6 @@ static struct bin_attribute w1_f29_sysfs_bin_files[NB_SYSFS_BIN_FILES] = {
 		},
 		.size = 1,
 		.read = w1_f29_read_cond_search_mask,
-		.write = 0,
 	},
 	{
 		.attr =	{
@@ -341,7 +340,6 @@ static struct bin_attribute w1_f29_sysfs_bin_files[NB_SYSFS_BIN_FILES] = {
 		},
 		.size = 1,
 		.read = w1_f29_read_cond_search_polarity,
-		.write = 0,
 	},
 	{
 		.attr =	{
