Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1HITkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:40:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58062 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1HITjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:39:16 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 3/8] drivers:misc: ti-st: reinit completion on ver read
Date: Tue, 9 Aug 2011 14:39:04 -0500
Message-ID: <1312918749-29627-13-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1312918749-29627-12-git-send-email-pavan_savoy@ti.com>
References: <1312918749-29627-1-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-2-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-3-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-4-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-5-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-6-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-7-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-8-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-9-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-10-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-11-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-12-git-send-email-pavan_savoy@ti.com>
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

Change-Id: Ia75485b83992ecbdd70cfcf15a41f551a1d86c56
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

