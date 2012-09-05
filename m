Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2IEAgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:36:31 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:39853
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758013Ab2IEAg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:36:28 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: kvp: Copy the address family information
Date: Tue,  4 Sep 2012 17:54:13 -0700
Message-Id: <1346806453-26933-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of the IP injection protocol in that the host expects this field 
to reflect what addresses (address families) are currently bound to the
interface. The KVP daemon is currently collecting this information and sending
it to the kernel component. I had overlooked copying this and sending it
back to the host. This patch addresses this issue.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_kvp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index d906050..ed50e9e 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -256,6 +256,8 @@ static int process_ob_ipinfo(void *in_msg, void *out_msg, int op)
 
 		out->kvp_ip_val.dhcp_enabled =
 			in->body.kvp_ip_val.dhcp_enabled;
+		out->kvp_ip_val.addr_family =
+			in->body.kvp_ip_val.addr_family;
 	}
 
 	return 0;
-- 
1.7.4.1

