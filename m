Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab0HDSUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:20:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55249 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab0HDSU3 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com, Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>,
        Jan Beulich <jbeulich@novell.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 19/20] xenbus: prevent warnings on unhandled enumeration values
Date: Wed,  4 Aug 2010 14:19:14 -0400
Message-Id: <1280945955-14229-20-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C59AF5D.01BC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>

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
index 82ed403..61c6a11 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -967,6 +967,8 @@ static void backend_changed(struct xenbus_device *dev,
 	case XenbusStateInitialising:
 	case XenbusStateInitWait:
 	case XenbusStateInitialised:
+	case XenbusStateReconfiguring:
+	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
 		break;
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index e140816..067d430 100644
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
index d504e2b..3eae5db 100644
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
index fa97d3e..67fb98a 100644
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
1.7.0.1

