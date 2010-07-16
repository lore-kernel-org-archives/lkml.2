Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250Ab0GPLMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:12:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:59079 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965150Ab0GPLLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:11:42 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: [PATCH 7/7] Documentation: Add new /sys/kernel/debug/ec/* files to ABI
Date: Fri, 16 Jul 2010 13:11:37 +0200
Message-Id: <1279278697-3694-8-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1279278697-3694-1-git-send-email-trenn@suse.de>
References: <1279278697-3694-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Renninger <trenn@suse.de>

CC: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org
CC: linux-acpi@vger.kernel.org
CC: platform-driver-x86@vger.kernel.org
---
 Documentation/ABI/testing/debugfs-ec |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-ec

diff --git a/Documentation/ABI/testing/debugfs-ec b/Documentation/ABI/testing/debugfs-ec
new file mode 100644
index 0000000..6546115
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-ec
@@ -0,0 +1,20 @@
+What:		/sys/kernel/debug/ec/*/{gpe,use_global_lock,io}
+Date:		July 2010
+Contact:	Thomas Renninger <trenn@suse.de>
+Description:
+
+General information like which GPE is assigned to the EC and whether
+the global lock should get used.
+Knowing the EC GPE one can watch the amount of HW events related to
+the EC here (XY -> GPE number from /sys/kernel/debug/ec/*/gpe):
+/sys/firmware/acpi/interrupts/gpeXY
+
+The io file is binary and a userspace tool located here:
+ftp://ftp.suse.com/pub/people/trenn/sources/ec/
+should get used to read out the 256 Embedded Controller registers
+or writing to them.
+
+CAUTION: Do not write to the Embedded Controller if you don't know
+what you are doing! Rebooting afterwards also is a good idea.
+This can influence the way your machine is cooled and fans may
+not get switched on again after you did a wrong write.
-- 
1.6.3

