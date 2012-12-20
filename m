Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2LTTOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:14:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48807 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2LTTNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:42 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Amit Shah <amit.shah@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] virtio_console: correct error message on failure of debugfs_create_dir
Date: Thu, 20 Dec 2012 14:11:21 -0500
Message-Id: <1356030701-16284-13-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs_create_dir() returns NULL if it fails, there's little point in
calling PTR_ERR on it.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/char/virtio_console.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index c594cb1..490b70e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2212,10 +2212,9 @@ static int __init init(void)
 	}
 
 	pdrvdata.debugfs_dir = debugfs_create_dir("virtio-ports", NULL);
-	if (!pdrvdata.debugfs_dir) {
-		pr_warning("Error %ld creating debugfs dir for virtio-ports\n",
-			   PTR_ERR(pdrvdata.debugfs_dir));
-	}
+	if (!pdrvdata.debugfs_dir)
+		pr_warn("Error creating debugfs dir for virtio-ports\n");
+
 	INIT_LIST_HEAD(&pdrvdata.consoles);
 	INIT_LIST_HEAD(&pdrvdata.portdevs);
 
-- 
1.8.0

