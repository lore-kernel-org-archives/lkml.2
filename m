Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2HMQwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:52:44 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55574
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752940Ab2HMQus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:50:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 11/18] Tools: hv: Gather DNS information
Date: Mon, 13 Aug 2012 10:07:00 -0700
Message-Id: <1344877627-21779-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1344877627-21779-1-git-send-email-kys@microsoft.com>
References: <1344877584-21738-1-git-send-email-kys@microsoft.com>
 <1344877627-21779-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, gather DNS information. Invoke an external script (that can be
distro dependent) to gather the DNS information.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Olaf Hering <olaf@aepfle.de>
Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/hv/hv_kvp_daemon.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 65d54c8..2f8e0b9 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -550,6 +550,29 @@ static void kvp_get_ipconfig_info(char *if_name,
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

