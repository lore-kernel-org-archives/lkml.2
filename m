Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1HJPUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:20:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57148 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1HJPSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:18:46 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 3/8] drivers:misc: ti-st: reinit completion on ver read
Date: Wed, 10 Aug 2011 10:18:32 -0500
Message-ID: <1312989517-28604-4-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1312989517-28604-3-git-send-email-pavan_savoy@ti.com>
References: <1312989517-28604-1-git-send-email-pavan_savoy@ti.com>
 <1312989517-28604-2-git-send-email-pavan_savoy@ti.com>
 <1312989517-28604-3-git-send-email-pavan_savoy@ti.com>
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
index d3d5b36..7e5ebf9 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -211,6 +211,7 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 		pr_err(" waiting for ver info- timed out ");
 		return -ETIMEDOUT;
 	}
+	INIT_COMPLETION(kim_gdata->kim_rcvd);
 
 	version =
 		MAKEWORD(kim_gdata->resp_buffer[13],
-- 
1.7.4.1

