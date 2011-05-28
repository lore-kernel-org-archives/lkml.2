Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1E1RhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:37:21 -0400
Received: from mail.perches.com ([173.55.12.10]:2226 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab1E1RhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:37:16 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH next 11/15] staging: Convert vmalloc/memset to vzalloc
Date: Sat, 28 May 2011 10:36:31 -0700
Message-Id: <e88a87ee0642dcc35c51daa24add02e33c53c59e.1306603968.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rts_pstor/ms.c        |    3 +--
 drivers/staging/rts_pstor/rtsx_chip.c |    6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index 2e82587..66341df 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -2064,11 +2064,10 @@ static int ms_init_l2p_tbl(struct rtsx_chip *chip)
 	RTSX_DEBUGP("ms_card->segment_cnt = %d\n", ms_card->segment_cnt);
 
 	size = ms_card->segment_cnt * sizeof(struct zone_entry);
-	ms_card->segment = (struct zone_entry *)vmalloc(size);
+	ms_card->segment = vzalloc(size);
 	if (ms_card->segment == NULL) {
 		TRACE_RET(chip, STATUS_FAIL);
 	}
-	memset(ms_card->segment, 0, size);
 
 	retval = ms_read_page(chip, ms_card->boot_block, 1);
 	if (retval != STATUS_SUCCESS) {
diff --git a/drivers/staging/rts_pstor/rtsx_chip.c b/drivers/staging/rts_pstor/rtsx_chip.c
index 4e60780..5452069 100644
--- a/drivers/staging/rts_pstor/rtsx_chip.c
+++ b/drivers/staging/rts_pstor/rtsx_chip.c
@@ -1596,18 +1596,16 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf, int l
 	}
 	RTSX_DEBUGP("dw_len = %d\n", dw_len);
 
-	data = (u32 *)vmalloc(dw_len * 4);
+	data = vzalloc(dw_len * 4);
 	if (!data) {
 		TRACE_RET(chip, STATUS_NOMEM);
 	}
-	memset(data, 0, dw_len * 4);
 
-	mask = (u32 *)vmalloc(dw_len * 4);
+	mask = vzalloc(dw_len * 4);
 	if (!mask) {
 		vfree(data);
 		TRACE_RET(chip, STATUS_NOMEM);
 	}
-	memset(mask, 0, dw_len * 4);
 
 	j = 0;
 	for (i = 0; i < len; i++) {
-- 
1.7.5.rc3.dirty

