Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1GORgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:36:13 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60206
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754207Ab1GORaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:09 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 092/117] Staging: hv: netvsc: Prevent outgoing traffic when netvsc dev is destroyed
Date: Fri, 15 Jul 2011 10:47:20 -0700
Message-Id: <1310752065-27895-92-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent outgoing traffic when netvsc dev is destroyed.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 2ee3f07..538259d 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -58,7 +58,8 @@ static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 
 	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device = device->ext;
-	if (net_device && atomic_read(&net_device->refcnt) > 1)
+	if (net_device && (atomic_read(&net_device->refcnt) > 1) &&
+		!net_device->destroy)
 		atomic_inc(&net_device->refcnt);
 	else
 		net_device = NULL;
-- 
1.7.4.1

