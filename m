Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab1EHXCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:02:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40833 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab1EHWkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K2mpB/GrYmWC7+2SGf3MJZpi1qZNpuEPF8ahLimSSC38QNE3GFQbKWGyZsPwgoXMt/
         jxO2XJ3JKK0fpDvvFj1rD3MWyLWqM1HLPMtDXhBRcWdCC5JLbBr7KOY85+h+mwFduJRC
         OdhA5Jsv3Aw+1ksBaa55YSqN0jretq01onGBE=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 020/115] sysctl: remove .child from coda/
Date: Mon,  9 May 2011 00:38:32 +0200
Message-Id: <1304894407-32201-21-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/coda/sysctl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index af56ad5..8c328c9 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -39,19 +39,15 @@ static ctl_table coda_table[] = {
 	{}
 };
 
-static ctl_table fs_table[] = {
-	{
-		.procname	= "coda",
-		.mode		= 0555,
-		.child		= coda_table
-	},
-	{}
+static const __initdata struct ctl_path coda_path[] = {
+	{ .procname = "coda" },
+	{ }
 };
 
 void coda_sysctl_init(void)
 {
 	if ( !fs_table_header )
-		fs_table_header = register_sysctl_table(fs_table);
+		fs_table_header = register_sysctl_paths(coda_path, coda_table);
 }
 
 void coda_sysctl_clean(void)
-- 
1.7.5.134.g1c08b

