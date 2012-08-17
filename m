Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab2HQBQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:16:38 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53595
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933121Ab2HQBPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:15:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V3 14/14] Tools: hv: Correctly type string variables
Date: Thu, 16 Aug 2012 18:32:25 -0700
Message-Id: <1345167145-5513-14-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1345167145-5513-1-git-send-email-kys@microsoft.com>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly type character strings.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 4a1428c..c8e1013 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -101,8 +101,8 @@ static struct utsname uts_buf;
 #define ENTRIES_PER_BLOCK 50
 
 struct kvp_record {
-	__u8 key[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
-	__u8 value[HV_KVP_EXCHANGE_MAX_VALUE_SIZE];
+	char key[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
+	char value[HV_KVP_EXCHANGE_MAX_VALUE_SIZE];
 };
 
 struct kvp_file_state {
@@ -110,7 +110,7 @@ struct kvp_file_state {
 	int num_blocks;
 	struct kvp_record *records;
 	int num_records;
-	__u8 fname[MAX_FILE_NAME];
+	char fname[MAX_FILE_NAME];
 };
 
 static struct kvp_file_state kvp_file_info[KVP_POOL_COUNT];
@@ -214,7 +214,7 @@ static int kvp_file_init(void)
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

