Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab2IEUc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:32:28 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53468
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754853Ab2IEUc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:32:26 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V5 1/6] Tools: hv: Add an example script to retrieve dhcp state
Date: Wed,  5 Sep 2012 13:50:10 -0700
Message-Id: <1346878215-30863-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346878188-30822-1-git-send-email-kys@microsoft.com>
References: <1346878188-30822-1-git-send-email-kys@microsoft.com>
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
 tools/hv/hv_get_dhcp_info.sh |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100755 tools/hv/hv_get_dhcp_info.sh

diff --git a/tools/hv/hv_get_dhcp_info.sh b/tools/hv/hv_get_dhcp_info.sh
new file mode 100755
index 0000000..ccd3e95
--- /dev/null
+++ b/tools/hv/hv_get_dhcp_info.sh
@@ -0,0 +1,28 @@
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
+#	that DHCP is enabled on the interface. If DHCP is not enabled,
+#	the script prints the string "Disabled" to stdout.
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
+else
+echo "Disabled"
+fi
-- 
1.7.4.1

