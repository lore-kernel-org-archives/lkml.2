Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2JDVSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:18:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63596 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab2JDVSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:18:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [ 22/56] tools/hv: Fix file handle leak
Date: Thu,  4 Oct 2012 14:15:43 -0700
Message-Id: <20121004211154.625496576@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit d5ab482799e7c4c4b7c0aa67e8710dce28115d03 upstream.

Match up each fopen() with an fclose().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/hv/hv_kvp_daemon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -144,7 +144,7 @@ static void kvp_update_file(int pool)
 				sizeof(struct kvp_record),
 				kvp_file_info[pool].num_records, filep);
 
-	fflush(filep);
+	fclose(filep);
 	kvp_release_lock(pool);
 }
 
@@ -191,6 +191,7 @@ static void kvp_update_mem_state(int poo
 	kvp_file_info[pool].records = record;
 	kvp_file_info[pool].num_records = records_read;
 
+	fclose(filep);
 	kvp_release_lock(pool);
 }
 static int kvp_file_init(void)


