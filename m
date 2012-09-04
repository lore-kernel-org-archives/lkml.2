Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab2IDVg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:36:27 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60232
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757621Ab2IDVgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:36:24 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V4 04/10] Tools: hv: Gather DNS information
Date: Tue,  4 Sep 2012 14:46:36 -0700
Message-Id: <1346795202-25655-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346795202-25655-1-git-send-email-kys@microsoft.com>
References: <1346795156-25614-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, gather DNS information. Invoke an external script (that can be
distro dependent) to gather the DNS information.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 026bf0e..cfa23a1 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -549,6 +549,29 @@ static void kvp_get_ipconfig_info(char *if_name,
 	kvp_process_ipconfig_file(cmd, (char *)buffer->gate_way,
 				(MAX_GATEWAY_SIZE * 2), INET6_ADDRSTRLEN, 1);
 
+
+	/*
+	 * Gather the DNS  state.
+	 * Since there is no standard way to get this information
+	 * across various distributions of interest; we just invoke
+	 * an external script that needs to be ported across distros
+	 * of interest.
+	 *
+	 * Following is the expected format of the information from the script:
+	 *
+	 * ipaddr1 (nameserver1)
+	 * ipaddr2 (nameserver2)
+	 * .
+	 * .
+	 */
+
+	sprintf(cmd, "%s",  "hv_get_dns_info");
+
+	/*
+	 * Execute the command to gather DNS info.
+	 */
+	kvp_process_ipconfig_file(cmd, (char *)buffer->dns_addr,
+				(MAX_IP_ADDR_SIZE * 2), INET_ADDRSTRLEN, 0);
 }
 
 
-- 
1.7.4.1

