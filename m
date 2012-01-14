Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab2ANUKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:10:45 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:43952 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab2ANUKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:10:43 -0500
From: jhbird.choi@samsung.com
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] driver-core: Fix null reference in subsys_interface_unregister
Date: Sat, 14 Jan 2012 11:06:03 +0900
Message-Id: <1326506763-9821-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

Check if the sif is not NULL before de-referencing it

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/base/bus.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 99dc592..4ddb38b 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -1193,13 +1193,15 @@ EXPORT_SYMBOL_GPL(subsys_interface_register);
 
 void subsys_interface_unregister(struct subsys_interface *sif)
 {
-	struct bus_type *subsys = sif->subsys;
+	struct bus_type *subsys;
 	struct subsys_dev_iter iter;
 	struct device *dev;
 
-	if (!sif)
+	if (!sif || !sif->subsys)
 		return;
 
+	subsys = sif->subsys;
+
 	mutex_lock(&subsys->p->mutex);
 	list_del_init(&sif->node);
 	if (sif->remove_dev) {
-- 
1.7.1

