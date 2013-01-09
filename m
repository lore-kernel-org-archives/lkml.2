Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3AIJR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:17:58 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:33404 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab3AIJRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:17:55 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benoit Goby <benoit@android.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] usb: gadget: FunctionFS: Use kstrtoul()
Date: Wed,  9 Jan 2013 10:17:47 +0100
Message-Id: <a2f4648457ce533fd08d87ac044be5e759b4622b.1357722590.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
References: <1357703829-26621-1-git-send-email-benoit@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

kstrtoul() checks for overflow which simple_strtoul() does not pluss
it has “*end == 0” check in it as well.  As a side effect, a new
line character is now accepted, but this should not be an issue.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 Patch on top of v3.5 with Benoit Goby's “Fix missing braces in
 parse_opts” patch
 (<id:1357703829-26621-1-git-send-email-benoit@android.com>) applied.

 drivers/usb/gadget/f_fs.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 8c2f251..38388d7 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1103,8 +1103,8 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 		return 0;
 
 	for (;;) {
-		char *end, *eq, *comma;
 		unsigned long value;
+		char *eq, *comma;
 
 		/* Option limit */
 		comma = strchr(opts, ',');
@@ -1120,8 +1120,7 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 		*eq = 0;
 
 		/* Parse value */
-		value = simple_strtoul(eq + 1, &end, 0);
-		if (unlikely(*end != ',' && *end != 0)) {
+		if (kstrtoul(eq + 1, 0, &value)) {
 			pr_err("%s: invalid value: %s\n", opts, eq + 1);
 			return -EINVAL;
 		}
-- 
1.7.7.3

