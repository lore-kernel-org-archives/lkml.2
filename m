Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0CYXV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:21:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55183 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0CYXUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:20:42 -0400
From: pavan_savoy@ti.com
To: marcel@holtmann.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in,
       Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] Documentation:staging: add TODO and ABI to ti-st
Date: Thu, 25 Mar 2010 18:20:22 -0500
Message-Id: <1269559223-4043-8-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1269559223-4043-7-git-send-email-pavan_savoy@ti.com>
References: <1269559223-4043-1-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-2-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-3-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-4-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-5-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-6-git-send-email-pavan_savoy@ti.com>
 <1269559223-4043-7-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

A TODO file and a ABI to list the things to be done,
and user-space/kernel-space interface for this ldisc.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/TODO      |   19 +++++++++++++++++++
 drivers/staging/ti-st/sysfs-uim |   16 ++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/TODO
 create mode 100644 drivers/staging/ti-st/sysfs-uim

diff --git a/drivers/staging/ti-st/TODO b/drivers/staging/ti-st/TODO
new file mode 100644
index 0000000..2c4fe58
--- /dev/null
+++ b/drivers/staging/ti-st/TODO
@@ -0,0 +1,19 @@
+TODO:
+
+1. A per-device/tty port context required to support multiple devices
+on same platform.
+
+2. REMOVE the sysfs entry PID passing mechanism, since there should
+be a better way to request user-space to install line discipline.
+
+3. Re-view/Re-work on the locking.
+
+4. Re-structure to make the ldisc driver more generic for chipsets which mux
+multiple connectivity (BT, FM, GPS) upon 1 TTY port.
+
+5. Step up and maintain this driver to ensure that it continues
+to work.  Having the hardware for this is pretty much a
+requirement.  If this does not happen, the will be removed in
+the 2.6.35 kernel release.
+
+Please send patches to Greg Kroah-Hartman <greg@kroah.com>.
diff --git a/drivers/staging/ti-st/sysfs-uim b/drivers/staging/ti-st/sysfs-uim
new file mode 100644
index 0000000..10311af
--- /dev/null
+++ b/drivers/staging/ti-st/sysfs-uim
@@ -0,0 +1,16 @@
+What:           /sys/class/rfkill/rfkill%d/
+Date:           March 22
+Contact:        Pavan Savoy <pavan_savoy@ti.com>
+Description:
+		Creates the rfkill entries for Radio apps like
+		BT app, FM app or GPS app to toggle corresponding
+		cores of the chip
+
+What:           /dev/rfkill
+Date:           March 22
+Contact:        Pavan Savoy <pavan_savoy@ti.com>
+Description:
+		A daemon which maintains the ldisc installation and
+		uninstallation would be ppolling on this device and listening
+		on events which would suggest either to install or un-install
+		line discipline
-- 
1.5.4.3

