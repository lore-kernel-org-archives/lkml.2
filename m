Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab0JLPwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:52:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32448 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896Ab0JLPwv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:52:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Yosuke Iwamatsu <y-iwamatsu@darnok.org>,
        Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Yosuke Iwamatsu <y-iwamatsu@ab.jp.nec.com>
Subject: [PATCH 18/23] xenbus: Xen paravirtualised PCI hotplug support.
Date: Tue, 12 Oct 2010 11:44:26 -0400
Message-Id: <1286898271-32018-19-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yosuke Iwamatsu <y-iwamatsu@darnok.org>

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
index 7e49527..cdacf92 100644
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
1.7.0.4

