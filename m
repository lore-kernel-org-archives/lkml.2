Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab1F1QEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:04:21 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54568 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758884Ab1F1QCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:02:09 -0400
X-Sasl-enc: wYjeuy9Am7lcpxH0sC2HC/S0LiCIYwYQQJ91vd+7GU+I 1309276928
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/9] firmware: fix GOOGLE_SMI kconfig dependency warning
Date: Tue, 28 Jun 2011 09:01:58 -0700
Message-Id: <1309276926-1327-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20110628153911.GD32710@kroah.com>
References: <20110628153911.GD32710@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Is it meaningful/useful to enable EFI_VARS but not EFI?
That's what GOOGLE_SMI does.  Make it enable EFI also.

Fixes this kconfig dependency warning:

warning: (GOOGLE_SMI) selects EFI_VARS which has unmet direct dependencies (EFI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/google/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
index 87096b6..2f21b0b 100644
--- a/drivers/firmware/google/Kconfig
+++ b/drivers/firmware/google/Kconfig
@@ -13,6 +13,7 @@ menu "Google Firmware Drivers"
 config GOOGLE_SMI
 	tristate "SMI interface for Google platforms"
 	depends on ACPI && DMI
+	select EFI
 	select EFI_VARS
 	help
 	  Say Y here if you want to enable SMI callbacks for Google
-- 
1.7.5.4

