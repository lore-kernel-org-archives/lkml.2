Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab2IEVTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:19:52 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:36859
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759537Ab2IEVTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:19:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] tools/hv: Fix file handle leak
Date: Wed,  5 Sep 2012 14:37:35 -0700
Message-Id: <1346881057-31479-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346881020-31440-1-git-send-email-kys@microsoft.com>
References: <1346881020-31440-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

Match up each fopen() with an fclose().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: stable@vger.kernel.org
---
 tools/hv/hv_kvp_daemon.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index c8e1013..4514fb4 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -160,7 +160,7 @@ static void kvp_update_file(int pool)
 				sizeof(struct kvp_record),
 				kvp_file_info[pool].num_records, filep);
 
-	fflush(filep);
+	fclose(filep);
 	kvp_release_lock(pool);
 }
 
@@ -207,6 +207,7 @@ static void kvp_update_mem_state(int pool)
 	kvp_file_info[pool].records = record;
 	kvp_file_info[pool].num_records = records_read;
 
+	fclose(filep);
 	kvp_release_lock(pool);
 }
 static int kvp_file_init(void)
-- 
1.7.4.1

