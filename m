Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1GVQ43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 12:56:29 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:35890
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753822Ab1GVQ40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 12:56:26 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, OHering@novell.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: util: kvp: Fix the reported  OSVersion string
Date: Fri, 22 Jul 2011 10:14:31 -0700
Message-Id: <1311354871-13821-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current win7 host does not like it when we return the
complete kernel release information. Conform to what the host
expects.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/tools/hv_kvp_daemon.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/tools/hv_kvp_daemon.c b/drivers/staging/hv/tools/hv_kvp_daemon.c
index c230bae..6f3e5c2 100644
--- a/drivers/staging/hv/tools/hv_kvp_daemon.c
+++ b/drivers/staging/hv/tools/hv_kvp_daemon.c
@@ -119,6 +119,15 @@ void kvp_get_os_info(void)
 	os_build = uts_buf.release;
 	processor_arch = uts_buf.machine;
 
+	/*
+	 * The current windows host (win7) expects the build
+	 * string to be of the form: x.y.z
+	 * Strip additional information we may have.
+	 */
+	p = strchr(os_build, '-');
+	if (p)
+		*p = '\0';
+
 	file = fopen("/etc/SuSE-release", "r");
 	if (file != NULL)
 		goto kvp_osinfo_found;
-- 
1.7.4.1

