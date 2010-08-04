Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab0HDSVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:21:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56696 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab0HDSUu (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com, Yosuke Iwamatsu <y-iwamatsu@ab.jp.nec.com>,
        Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 18/20] xenbus: Xen paravirtualised PCI hotplug support.
Date: Wed,  4 Aug 2010 14:19:13 -0400
Message-Id: <1280945955-14229-19-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C59AF6F.0161:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yosuke Iwamatsu <y-iwamatsu@ab.jp.nec.com>

The Xen PCI front driver adds two new states that are utilizez
for PCI hotplug support. This is a patch pulled from the
linux-2.6-xen-sparse tree.

Signed-off-by: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Yosuke Iwamatsu <y-iwamatsu@ab.jp.nec.com>
---
 drivers/xen/xenbus/xenbus_client.c |    2 ++
 include/xen/interface/io/xenbus.h  |    8 +++++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 7b3e973..6066eb9 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -50,6 +50,8 @@ const char *xenbus_strstate(enum xenbus_state state)
 		[ XenbusStateConnected    ] = "Connected",
 		[ XenbusStateClosing      ] = "Closing",
 		[ XenbusStateClosed	  ] = "Closed",
+		[XenbusStateReconfiguring] = "Reconfiguring",
+		[XenbusStateReconfigured] = "Reconfigured",
 	};
 	return (state < ARRAY_SIZE(name)) ? name[state] : "INVALID";
 }
diff --git a/include/xen/interface/io/xenbus.h b/include/xen/interface/io/xenbus.h
index 46508c7..9fda532 100644
--- a/include/xen/interface/io/xenbus.h
+++ b/include/xen/interface/io/xenbus.h
@@ -27,8 +27,14 @@ enum xenbus_state
 	XenbusStateClosing      = 5,  /* The device is being closed
 					 due to an error or an unplug
 					 event. */
-	XenbusStateClosed       = 6
+	XenbusStateClosed       = 6,
 
+	/*
+	* Reconfiguring: The device is being reconfigured.
+	*/
+	XenbusStateReconfiguring = 7,
+
+	XenbusStateReconfigured  = 8
 };
 
 #endif /* _XEN_PUBLIC_IO_XENBUS_H */
-- 
1.7.0.1

