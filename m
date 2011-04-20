Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1DTOKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:10:17 -0400
Received: from smtp.nokia.com ([147.243.128.26]:50262 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab1DTOKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:10:16 -0400
From: Roman Borisov <ext-roman.borisov@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Roman Borisov <ext-roman.borisov@nokia.com>
Subject: [PATCH v2] fs: bound mount propagation fix
Date: Wed, 20 Apr 2011 18:11:53 +0400
Message-Id: <a5c94bcf545fe78cc600402a5234a6bbc1dece97.1303304011.git.ext-roman.borisov@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1303304011.git.ext-roman.borisov@nokia.com>
References: <cover.1303304011.git.ext-roman.borisov@nokia.com>
X-OriginalArrivalTime: 20 Apr 2011 14:09:54.0316 (UTC) FILETIME=[9F369CC0:01CBFF64]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MS_SILENT flag cleaning up added to flags_to_propagation_type function.
It was reported that bound mount propagation doesn't work in busybox as by
default busybox mount applet sets the MS_SILENT flag for any mount operation.
Moreover recently added flags_to_propagation_type function doesn't allow to
do such operations as --make-[r]private --make-[r]shared etc. when MS_SILENT
is on.
The idea to clean MS_SILENT flag belongs to Denys Vlasenko <vda.linux@googlemail.com>

Signed-off-by: Roman Borisov <ext-roman.borisov@nokia.com>
---
 fs/namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 60813f0..f219060 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1423,7 +1423,7 @@ out_unlock:
 
 static int flags_to_propagation_type(int flags)
 {
-	int type = flags & ~MS_REC;
+	int type = flags & ~(MS_REC | MS_SILENT);
 
 	/* Fail if any non-propagation flags are set */
 	if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
-- 
1.7.0.4

