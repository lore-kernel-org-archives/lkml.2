Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2GXPrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:47:07 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39827
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755559Ab2GXPqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:46:37 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, netdev@vger.kernel.org,
        ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 17/17] Tools: hv: Correctly type string variables
Date: Tue, 24 Jul 2012 09:01:41 -0700
Message-Id: <1343145701-3691-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1343145701-3691-1-git-send-email-kys@microsoft.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly type character strings. I would like to thank Ben Hutchings
for pointing out the issue (ben@decadent.org.uk).

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index e72d6db..3746033 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -96,8 +96,8 @@ static struct utsname uts_buf;
 #define ENTRIES_PER_BLOCK 50
 
 struct kvp_record {
-	__u8 key[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
-	__u8 value[HV_KVP_EXCHANGE_MAX_VALUE_SIZE];
+	char key[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
+	char value[HV_KVP_EXCHANGE_MAX_VALUE_SIZE];
 };
 
 struct kvp_file_state {
@@ -105,7 +105,7 @@ struct kvp_file_state {
 	int num_blocks;
 	struct kvp_record *records;
 	int num_records;
-	__u8 fname[MAX_FILE_NAME];
+	char fname[MAX_FILE_NAME];
 };
 
 static struct kvp_file_state kvp_file_info[KVP_POOL_COUNT];
@@ -209,7 +209,7 @@ static int kvp_file_init(void)
 	int  fd;
 	FILE *filep;
 	size_t records_read;
-	__u8 *fname;
+	char *fname;
 	struct kvp_record *record;
 	struct kvp_record *readp;
 	int num_blocks;
-- 
1.7.4.1

