Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2HMQu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:50:57 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55573
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752915Ab2HMQus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:50:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 18/18] Tools: hv: Properly manage open streams
Date: Mon, 13 Aug 2012 10:07:07 -0700
Message-Id: <1344877627-21779-18-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1344877627-21779-1-git-send-email-kys@microsoft.com>
References: <1344877584-21738-1-git-send-email-kys@microsoft.com>
 <1344877627-21779-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Close the open streams properly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Olaf Hering <olaf@aepfle.de>
Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/hv/hv_kvp_daemon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index c8e1013..ca6424f 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -160,7 +160,7 @@ static void kvp_update_file(int pool)
 				sizeof(struct kvp_record),
 				kvp_file_info[pool].num_records, filep);
 
-	fflush(filep);
+	fclose(filep);
 	kvp_release_lock(pool);
 }
 
@@ -206,7 +206,7 @@ static void kvp_update_mem_state(int pool)
 	kvp_file_info[pool].num_blocks = num_blocks;
 	kvp_file_info[pool].records = record;
 	kvp_file_info[pool].num_records = records_read;
-
+	fclose(filep);
 	kvp_release_lock(pool);
 }
 static int kvp_file_init(void)
-- 
1.7.4.1

