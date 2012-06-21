Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab2FUGyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:54:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:58204 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757657Ab2FUGyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:54:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168363719"
From: "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Cihula, Joseph" <joseph.cihula@intel.com>,
        "Wei, Gang" <gang.wei@intel.com>,
        "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>,
        "srajiv@linux.vnet.ibm.com" <srajiv@linux.vnet.ibm.com>,
        "m.selhorst@sirrix.com" <m.selhorst@sirrix.com>,
        "shpedoikal@gmail.com" <shpedoikal@gmail.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>
Subject: [PATCH V3 2/2] Documentation: sysfs for Physical Presence Interface
Thread-Topic: [PATCH V3 2/2] Documentation: sysfs for Physical Presence
 Interface
Thread-Index: Ac1Per4sOjlyN/ayTluuCfJhyr62OA==
Date: Thu, 21 Jun 2012 06:54:46 +0000
Message-ID: <1340203958.24516.1.camel@localhost>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.48.101]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5L6svEo009371

From: Xiaoyan Zhang <xiaoyan.zhang@intel.com>


Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-ppi |   70 ++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ppi

diff --git a/Documentation/ABI/testing/sysfs-driver-ppi b/Documentation/ABI/testing/sysfs-driver-ppi
new file mode 100644
index 0000000..5da9acd
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-ppi
@@ -0,0 +1,70 @@
+What:		/sys/devices/pnp0/<bus-num>/ppi/
+Date:		June 2012
+Kernel Version:	3.4
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This folder includes the attributes related with PPI (Physical
+		Presence Interface). Only if TPM is supported by BIOS, this
+		folder makes sence. The folder path can be got by command
+		'find /sys/ -name 'pcrs''. For the detail information of PPI,
+		please refer to the PPI specification from
+		http://www.trustedcomputinggroup.org/
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/version
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the version of the PPI supported by the
+		platform.
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/request
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the request for an operation to be
+		executed in the pre-OS environment. It is the only input from
+		the OS to the pre-OS environment. The request should be an
+		integer value range from 1 to 160, and 0 means no request.
+		This file can be read and written.
+
+What:		/sys/devices/pnp0/00:<bus-num>/ppi/response
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the response to the most recent operation
+		request it acted upon. The format is "<request> <response num>
+		: <response description>".
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/transition_action
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the platform-specific action that should
+		take place in order to transition to the BIOS for execution of
+		a requested operation. The format is "<action num>: <action
+		description>".
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/tcg_operations
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows whether it is allowed to request an
+		operation to be executed in the pre-OS environment by the BIOS
+		for the requests defined by TCG, i.e. requests from 1 to 22.
+		The format is "<request> <status num>: <status description>".
+		This attribute is only supported by PPI version 1.2+.
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/vs_operations
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows whether it is allowed to request an
+		operation to be executed in the pre-OS environment by the BIOS
+		for the verdor specific requests, i.e. requests from 128 to
+		255. The format is same with tcg_operations. This attribute
+		is also only supported by PPI version 1.2+.
+		This file is readonly.
-- 
1.7.6.5

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
