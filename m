Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1HZUfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:35:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab1HZUeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/13] drivers:misc: ti-st: reinit completion on ver read
Date: Fri, 26 Aug 2011 13:33:49 -0700
Message-Id: <1314390834-3411-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

After the version information has been read, the completion which assists in
wait_for_completion during the firmware send/wait sequence is being re-used
and hence this needs to be re-initialised for fool proof firmware download
retries.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.6.1

