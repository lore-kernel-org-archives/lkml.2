Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab2J2OU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:20:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50823 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab2J2OUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:20:54 -0400
X-Greylist: delayed 1069 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2012 10:20:54 EDT
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jan Beulich <JBeulich@suse.com>, Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/xenbus: fix overflow check in xenbus_file_write()
Date: Mon, 29 Oct 2012 10:08:18 -0400
Message-Id: <1351519698-11069-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351519698-11069-1-git-send-email-konrad.wilk@oracle.com>
References: <1351519698-11069-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
[v1: Rebased on upstream]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xenbus/xenbus_dev_frontend.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_dev_frontend.c b/drivers/xen/xenbus/xenbus_dev_frontend.c
index 89f7625..ac72702 100644
--- a/drivers/xen/xenbus/xenbus_dev_frontend.c
+++ b/drivers/xen/xenbus/xenbus_dev_frontend.c
@@ -458,7 +458,7 @@ static ssize_t xenbus_file_write(struct file *filp,
 		goto out;
 
 	/* Can't write a xenbus message larger we can buffer */
-	if ((len + u->len) > sizeof(u->u.buffer)) {
+	if (len > sizeof(u->u.buffer) - u->len) {
 		/* On error, dump existing buffer */
 		u->len = 0;
 		rc = -EINVAL;
-- 
1.7.7.6

