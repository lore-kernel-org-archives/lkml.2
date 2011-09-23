Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab1IWUnC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:43:02 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:52744 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1IWUnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:43:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1316810533!22011019!31
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] exofs/ore.c: local functions should be static
Date: Fri, 23 Sep 2011 13:42:43 -0700
User-Agent: KMail/1.9.9
CC: <osd-dev@open-osd.org>, <bharrosh@panasas.com>, <bhalevy@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231342.43853.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quiets the sparse noise:

warning: symbol '_calc_trunk_info' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>

---

diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 25305af..6114fdf 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -753,8 +753,8 @@ struct _trunc_info {
 	unsigned max_devs;
 };
 
-void _calc_trunk_info(struct ore_layout *layout, u64 file_offset,
-		       struct _trunc_info *ti)
+static void _calc_trunk_info(struct ore_layout *layout, u64 file_offset,
+			     struct _trunc_info *ti)
 {
 	unsigned stripe_unit = layout->stripe_unit;
 
