Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab2IDV3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:29:54 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:50656
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757858Ab2IDV26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:28:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V4 05/10] Tools: hv: Add an example script to retrieve dhcp state
Date: Tue,  4 Sep 2012 14:46:37 -0700
Message-Id: <1346795202-25655-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346795202-25655-1-git-send-email-kys@microsoft.com>
References: <1346795156-25614-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To keep the KVP daemon code free of distro specific details, we invoke an
external script to retrieve the DHCP state. This is an example script that
was used to test the KVP code. This script has to be implemented in a Distro
specific fashion. For instance on distros that ship with Network Manager enabled,
this script can be based on NM APIs.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_get_dhcp_info.sh |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100755 tools/hv/hv_get_dhcp_info.sh

diff --git a/tools/hv/hv_get_dhcp_info.sh b/tools/hv/hv_get_dhcp_info.sh
new file mode 100755
index 0000000..3de4587
--- /dev/null
+++ b/tools/hv/hv_get_dhcp_info.sh
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+# This example script retrieves the DHCP state of a given interface.
+# In the interest of keeping the KVP daemon code free of distro specific
+# information; the kvp daemon code invokes this external script to gather
+# DHCP setting for the specific interface.
+#
+# Input: Name of the interface
+#
+# Output: The script prints the string "Enabled" to stdout to indicate
+#	that DHCP is enabled on the interface.
+#
+# Each Distro is expected to implement this script in a distro specific
+# fashion. For instance on Distros that ship with Network Manager enabled,
+# this script can be based on the Network Manager APIs for retrieving DHCP
+# information.
+
+if_file="/etc/sysconfig/network-scripts/ifcfg-"$1
+
+dhcp=$(grep "dhcp" $if_file 2>/dev/null)
+
+if [ "$dhcp" != "" ];
+then
+echo "Enabled"
+fi
-- 
1.7.4.1

