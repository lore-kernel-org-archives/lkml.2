Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab2IDVhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:37:02 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35088
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757919Ab2IDVg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:36:26 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V4 02/10] Tools: hv: Correctly type string variables
Date: Tue,  4 Sep 2012 14:46:34 -0700
Message-Id: <1346795202-25655-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346795202-25655-1-git-send-email-kys@microsoft.com>
References: <1346795156-25614-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-1-git-send-email-kys@microsoft.com>
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
index d12d714..026bf0e 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -86,8 +86,8 @@ static struct utsname uts_buf;
 #define ENTRIES_PER_BLOCK 50
 
 struct kvp_record {
-	__u8 key[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
-	__u8 value[HV_KVP_EXCHANGE_MAX_VALUE_SIZE];
+	char key[HV_KVP_EXCHANGE_MAX_KEY_SIZE];
+	char value[HV_KVP_EXCHANGE_MAX_VALUE_SIZE];
 };
 
 struct kvp_file_state {
@@ -95,7 +95,7 @@ struct kvp_file_state {
 	int num_blocks;
 	struct kvp_record *records;
 	int num_records;
-	__u8 fname[MAX_FILE_NAME];
+	char fname[MAX_FILE_NAME];
 };
 
 static struct kvp_file_state kvp_file_info[KVP_POOL_COUNT];
@@ -199,7 +199,7 @@ static int kvp_file_init(void)
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

