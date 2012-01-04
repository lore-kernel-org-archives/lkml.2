Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2ADLj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 06:39:59 -0500
Received: from smtp.citrix.com ([66.165.176.89]:27807 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2ADLj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 06:39:58 -0500
X-IronPort-AV: E=Sophos;i="4.71,455,1320642000"; 
   d="scan'208";a="20534540"
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <ian.campbell@citrix.com>,
        Haogang Chen <haogangchen@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] xenbus: maximum buffer size is XENSTORE_PAYLOAD_MAX
Date: Wed, 4 Jan 2012 11:39:51 +0000
Message-ID: <1325677192-10459-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1325677158.25206.244.camel@zakaz.uk.xensource.com>
References: <1325677158.25206.244.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this now that it is defined even though it happens to be == PAGE_SIZE.

The code which takes requests from userspace already validates against the size
of this buffer so no further checks are required to ensure that userspace
requests comply with the protocol in this respect.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Haogang Chen <haogangchen@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/xen/xenbus/xenbus_dev_frontend.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_dev_frontend.c b/drivers/xen/xenbus/xenbus_dev_frontend.c
index fb30cff..1fe4324 100644
--- a/drivers/xen/xenbus/xenbus_dev_frontend.c
+++ b/drivers/xen/xenbus/xenbus_dev_frontend.c
@@ -104,7 +104,7 @@ struct xenbus_file_priv {
 	unsigned int len;
 	union {
 		struct xsd_sockmsg msg;
-		char buffer[PAGE_SIZE];
+		char buffer[XENSTORE_PAYLOAD_MAX];
 	} u;
 
 	/* Response queue. */
-- 
1.7.2.5

