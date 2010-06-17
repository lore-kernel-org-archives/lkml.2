Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab0FQAlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:41:08 -0400
Received: from [159.226.40.154] ([159.226.40.154]:39548 "EHLO mail.loongson.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab0FQAlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:41:06 -0400
From: qiaochong <qiaochong@loongson.cn>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jsimmons@infradead.org,
       qiaochong@loongson.cn
Subject: [PATCH 2/2] Variable end on vc_do_resize should be unsigned long.
Date: Thu, 17 Jun 2010 08:41:25 +0800
Message-Id: <1276735285-7045-3-git-send-email-qiaochong@loongson.cn>
X-Mailer: git-send-email 1.7.0.3.254.g4503b.dirty
In-Reply-To: <1276735285-7045-1-git-send-email-qiaochong@loongson.cn>
References: <1276735285-7045-1-git-send-email-qiaochong@loongson.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According include/linux/console_struct.h,vc_scr_end is unsigned long.

struct vc_data {
    unsigned short  vc_num;         /* Console number */
    unsigned int    vc_cols;        /* [#] Console size */
    unsigned int    vc_rows;
    unsigned int    vc_size_row;        /* Bytes per row */
    unsigned int    vc_scan_lines;      /* # of scan lines */
    unsigned long   vc_origin;      /* [!] Start of real screen */
    unsigned long   vc_scr_end;     /* [!] End of real screen */
    unsigned long   vc_visible_origin;  /* [!] Top of visible window */
    unsigned int    vc_top, vc_bottom;  /* Scrolling region */
    const struct consw *vc_sw;
    unsigned short  *vc_screenbuf;
...
}
Signed-off-by: qiaochong <qiaochong@loongson.cn>
---
 drivers/char/vt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 29a5bdc..baabd02 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -831,9 +831,10 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 				unsigned int cols, unsigned int lines)
 {
 	unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
+	unsigned long end;
 	unsigned int old_cols, old_rows, old_row_size, old_screen_size;
 	unsigned int new_cols, new_rows, new_row_size, new_screen_size;
-	unsigned int end, user;
+	unsigned int user;
 	unsigned short *newscreen;
 
 	WARN_CONSOLE_UNLOCKED();
-- 
1.5.6.5

