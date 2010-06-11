Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab0FKA1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:27:37 -0400
Received: from [159.226.40.154] ([159.226.40.154]:57678 "EHLO mail.loongson.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab0FKA1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:27:36 -0400
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jun 2010 20:27:36 EDT
From: qiaochong <qiaochong@loongson.cn>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jsimmons@infradead.org,
       qiaochong@loongson.cn
Subject: [PATCH 2/2] Variable end on vc_do_resize should be unsigned long.
Date: Fri, 11 Jun 2010 08:19:08 +0800
Message-Id: <1276215548-18479-3-git-send-email-qiaochong@loongson.cn>
X-Mailer: git-send-email 1.7.0.3.254.g4503b.dirty
In-Reply-To: <1276215548-18479-1-git-send-email-qiaochong@loongson.cn>
References: <1276215548-18479-1-git-send-email-qiaochong@loongson.cn>
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
 drivers/char/vt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 6a22f87..81cc361 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -830,10 +830,10 @@ static inline int resize_screen(struct vc_data *vc, int width, int height,
 static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 				unsigned int cols, unsigned int lines)
 {
-	unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
+	unsigned long old_origin, new_origin, new_scr_end, end, rlth, rrem, err = 0;
 	unsigned int old_cols, old_rows, old_row_size, old_screen_size;
 	unsigned int new_cols, new_rows, new_row_size, new_screen_size;
-	unsigned int end, user;
+	unsigned int user;
 	unsigned short *newscreen;
 
 	WARN_CONSOLE_UNLOCKED();
-- 
1.7.0.3.254.g4503b.dirty

