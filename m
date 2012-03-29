Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab2C2Omt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:42:49 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42784 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759489Ab2C2Om0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:42:26 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v4 03/12] ima: free securityfs violations file
Date: Thu, 29 Mar 2012 10:41:31 -0400
Message-Id: <1333032100-4159-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032914-5806-0000-0000-000013D8F3D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

On ima_fs_init() error, free securityfs violations file.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/ima/ima_fs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index e1aa2b4..3fccc06 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -367,6 +367,7 @@ int __init ima_fs_init(void)
 
 	return 0;
 out:
+	securityfs_remove(violations);
 	securityfs_remove(runtime_measurements_count);
 	securityfs_remove(ascii_runtime_measurements);
 	securityfs_remove(binary_runtime_measurements);
-- 
1.7.6.5

