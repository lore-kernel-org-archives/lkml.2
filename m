Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab0JLPrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:47:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28348 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab0JLPrA (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:47:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Noboru Iwamatsu <n_iwamatsu@darnok.org>,
        Jan Beulich <jbeulich@novell.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 19/23] xenbus: prevent warnings on unhandled enumeration values
Date: Tue, 12 Oct 2010 11:44:27 -0400
Message-Id: <1286898271-32018-20-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Noboru Iwamatsu <n_iwamatsu@darnok.org>

XenbusStateReconfiguring/XenbusStateReconfigured were introduced by
c/s 437, but aren't handled in many switch statements.

.. also pulled from the linux-2.6-sparse-tree tree.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |    2 ++
 drivers/input/xen-kbdfront.c |    2 ++
 drivers/net/xen-netfront.c   |    2 ++
 drivers/video/xen-fbfront.c  |    2 ++
 4 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index ab735a6..c4e9d81 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1125,6 +1125,8 @@ static void blkback_changed(struct xenbus_device *dev,
 	case XenbusStateInitialising:
 	case XenbusStateInitWait:
 	case XenbusStateInitialised:
+	case XenbusStateReconfiguring:
+	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
 		break;
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index ebb1190..e0c024d 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -276,6 +276,8 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 	switch (backend_state) {
 	case XenbusStateInitialising:
 	case XenbusStateInitialised:
+	case XenbusStateReconfiguring:
+	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
 		break;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index b50fedc..cb6e112 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1610,6 +1610,8 @@ static void backend_changed(struct xenbus_device *dev,
 	switch (backend_state) {
 	case XenbusStateInitialising:
 	case XenbusStateInitialised:
+	case XenbusStateReconfiguring:
+	case XenbusStateReconfigured:
 	case XenbusStateConnected:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 7c7f42a..428d273 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -631,6 +631,8 @@ static void xenfb_backend_changed(struct xenbus_device *dev,
 	switch (backend_state) {
 	case XenbusStateInitialising:
 	case XenbusStateInitialised:
+	case XenbusStateReconfiguring:
+	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
 		break;
-- 
1.7.0.4

