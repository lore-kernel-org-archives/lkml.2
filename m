Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2LAOYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:24:16 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55724
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 27/28] Drivers: hv: Capture the host build information
Date: Sat,  1 Dec 2012 06:46:58 -0800
Message-Id: <1354373219-31374-27-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Capture the host build information so it can be presented along with the
negotiated vmbus version information.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv.c           |    9 +++++++++
 drivers/hv/hyperv_vmbus.h |    7 +++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 03e6a1e..0cd2da3 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -40,6 +40,11 @@ struct hv_context hv_context = {
 /*
  * query_hypervisor_info - Get version info of the windows hypervisor
  */
+unsigned int host_info_eax;
+unsigned int host_info_ebx;
+unsigned int host_info_ecx;
+unsigned int host_info_edx;
+
 static int query_hypervisor_info(void)
 {
 	unsigned int eax;
@@ -76,6 +81,10 @@ static int query_hypervisor_info(void)
 			    ecx,
 			    edx >> 24,
 			    edx & 0xFFFFFF);
+		host_info_eax = eax;
+		host_info_ebx = ebx;
+		host_info_ecx = ecx;
+		host_info_edx = edx;
 	}
 	return max_leaf;
 }
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index ac111f2..12f2f9e 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -531,6 +531,13 @@ extern void hv_synic_init(void *irqarg);
 
 extern void hv_synic_cleanup(void *arg);
 
+/*
+ * Host version information.
+ */
+extern unsigned int host_info_eax;
+extern unsigned int host_info_ebx;
+extern unsigned int host_info_ecx;
+extern unsigned int host_info_edx;
 
 /* Interface */
 
-- 
1.7.4.1

