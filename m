Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab2HQBTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:19:14 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40758
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932802Ab2HQBPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:15:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V3 08/14] Tools: hv: Gather DNS information
Date: Thu, 16 Aug 2012 18:32:19 -0700
Message-Id: <1345167145-5513-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1345167145-5513-1-git-send-email-kys@microsoft.com>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
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

