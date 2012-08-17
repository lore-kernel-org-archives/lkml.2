Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2HQA3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:29:24 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42553
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932527Ab2HQA2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:28:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 04/14] Tools: hv: Gather address family information
Date: Thu, 16 Aug 2012 17:45:15 -0700
Message-Id: <1345164325-5198-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1345164325-5198-1-git-send-email-kys@microsoft.com>
References: <1345164300-5146-1-git-send-email-kys@microsoft.com>
 <1345164325-5198-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/hv/hv_kvp_daemon.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 3dc989f..13ae098 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -589,6 +589,17 @@ kvp_get_ip_address(int family, char *if_name, int op,
 			continue;
 		}
 
+		if (op == KVP_OP_GET_IP_INFO) {
+			/*
+			 * Gather info other than the IP address.
+			 * IP address info will be gathered later.
+			 */
+			if (curp->ifa_addr->sa_family == AF_INET)
+				ip_buffer->addr_family |= ADDR_FAMILY_IPV4;
+			else
+				ip_buffer->addr_family |= ADDR_FAMILY_IPV6;
+		}
+
 		error = kvp_process_ip_address(curp->ifa_addr,
 						curp->ifa_addr->sa_family,
 						buffer,
-- 
1.7.4.1

