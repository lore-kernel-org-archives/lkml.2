Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030220Ab2B1Suz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:50:55 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35407 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756903Ab2B1Sux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:50:53 -0500
From: Joe Perches <joe@perches.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH trivial next 7/9] scsi: Use vsprintf extention %pf with builtin_return_address
Date: Tue, 28 Feb 2012 10:49:36 -0800
Message-Id: <aa5a8942edf8a59745a514a099e78eaaae03fe26.1330454853.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1330454853.git.joe@perches.com>
References: <cover.1330454853.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit the function name not the address when possible.

builtin_return_address() gives an address.  When building
a kernel with CONFIG_KALLSYMS, emit the actual function
name not the address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/esp_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 394ed9e..34552bf 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -1000,7 +1000,7 @@ static int esp_check_spur_intr(struct esp *esp)
 
 static void esp_schedule_reset(struct esp *esp)
 {
-	esp_log_reset("ESP: esp_schedule_reset() from %p\n",
+	esp_log_reset("ESP: esp_schedule_reset() from %pf\n",
 		      __builtin_return_address(0));
 	esp->flags |= ESP_FLAG_RESETTING;
 	esp_event(esp, ESP_EVENT_RESET);
-- 
1.7.8.111.gad25c.dirty

