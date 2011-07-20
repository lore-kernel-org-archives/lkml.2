Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab1GTObz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:31:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46651 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab1GTOab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:30:31 -0400
From: <pavan_savoy@ti.com>
To: <greg@kroah.com>, <linux-kernel@vger.kernel.org>
CC: pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 3/4] drivers:misc: ti-st: reinit completion on ver read
Date: Wed, 20 Jul 2011 09:30:24 -0500
Message-ID: <1311172225-17678-9-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1311172225-17678-8-git-send-email-pavan_savoy@ti.com>
References: <1311172225-17678-1-git-send-email-pavan_savoy@ti.com>
 <1311172225-17678-2-git-send-email-pavan_savoy@ti.com>
 <1311172225-17678-3-git-send-email-pavan_savoy@ti.com>
 <1311172225-17678-4-git-send-email-pavan_savoy@ti.com>
 <1311172225-17678-5-git-send-email-pavan_savoy@ti.com>
 <1311172225-17678-6-git-send-email-pavan_savoy@ti.com>
 <1311172225-17678-7-git-send-email-pavan_savoy@ti.com>
 <1311172225-17678-8-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

After the version information has been read, the completion which assists in
wait_for_completion during the firmware send/wait sequence is being re-used
and hence this needs to be re-initialised for fool proof firmware download
retries.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 6884dd1..e5639ca 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -210,6 +210,7 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 		pr_err(" waiting for ver info- timed out ");
 		return -ETIMEDOUT;
 	}
+	INIT_COMPLETION(kim_gdata->kim_rcvd);
 
 	version =
 		MAKEWORD(kim_gdata->resp_buffer[13],
-- 
1.7.4.1

