Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab1GNUfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 16:35:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53942 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab1GNUfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 16:35:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=DtJ0+hqb0FvB9OjLnuDUOUtvvjJ6bmfrMxKL4vMKs1BrAphRMKesAuPHrF946XWgC
	8zEJ7yGvCOhiZF7ChAYmg==
From: Mike Waychison <mikew@google.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: [PATCH 1/2] Kconfig:  Allow disabling of CONFIG_DEVPORT
Date: Thu, 14 Jul 2011 13:34:52 -0700
Message-Id: <1310675693-9204-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be useful to build kernels with disabled support of /dev/port
for systems where we do not want to allow an administrator to access IO
ports directly.

To do so however, CONFIG_DEVPORT needs to be user-selectable.  Give this
configuration option a name and help description.

Google-Bug-Id: 3177114
Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/char/Kconfig |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 49502bc..12503f1 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -593,10 +593,15 @@ config TELCLOCK
 	  controlling the behavior of this hardware.
 
 config DEVPORT
-	bool
+	bool "Support for /dev/port"
 	depends on !M68K
 	depends on ISA || PCI
 	default y
+	help
+	  Enabling this option allows for access to the /dev/port
+	  character device.  This device maps IO ports onto a file
+	  interface, so that users with sufficient privilege can read
+	  and write to IO ports directly.  If unsure, say yes.
 
 source "drivers/s390/char/Kconfig"
 
-- 
1.7.3.1

