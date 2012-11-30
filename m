Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992631Ab2K3S4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:56:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:58157 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031442Ab2K3S4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [ 02/56] NVMe: Fix uninitialized iod compiler warning
Date: Fri, 30 Nov 2012 10:54:54 -0800
Message-Id: <20121130185118.573869516@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <keith.busch@intel.com>

commit c7d36ab8fa04c213328119a9c0d66985fe204ee5 upstream.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/nvme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/nvme.c
+++ b/drivers/block/nvme.c
@@ -1153,7 +1153,7 @@ static int nvme_user_admin_cmd(struct nv
 	struct nvme_admin_cmd cmd;
 	struct nvme_command c;
 	int status, length;
-	struct nvme_iod *iod;
+	struct nvme_iod *uninitialized_var(iod);
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;


