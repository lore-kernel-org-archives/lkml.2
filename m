Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab2LTTMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:12:31 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20655 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2LTTMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:12:24 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] kvm tools: remove unneeded checks in qcow code
Date: Thu, 20 Dec 2012 14:11:10 -0500
Message-Id: <1356030701-16284-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already know q!=NULL at that point, no need to retest.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/kvm/disk/qcow.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/kvm/disk/qcow.c b/tools/kvm/disk/qcow.c
index ee2992e..64a2550 100644
--- a/tools/kvm/disk/qcow.c
+++ b/tools/kvm/disk/qcow.c
@@ -1361,8 +1361,7 @@ free_header:
 	if (q->header)
 		free(q->header);
 free_qcow:
-	if (q)
-		free(q);
+	free(q);
 
 	return NULL;
 }
@@ -1492,8 +1491,7 @@ free_header:
 	if (q->header)
 		free(q->header);
 free_qcow:
-	if (q)
-		free(q);
+	free(q);
 
 	return NULL;
 }
-- 
1.8.0

