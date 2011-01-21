Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1AUSvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:51:38 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:42557 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab1AUSvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:51:37 -0500
X-Greylist: delayed 735 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jan 2011 13:51:37 EST
MIME-Version: 1.0
Date: Fri, 21 Jan 2011 13:39:19 -0500
Message-ID: <AANLkTi=0W3hZs6bsCwttg9BBgoQs0v-qVO5x5UPnNM+k@mail.gmail.com>
Subject: [PATCH, TRIVIAL] Add more explicit dependencies for CONFIG_INTEL_TXT
From: Jonathan McCune <jonmccune@cmu.edu>
To: linux-kernel@vger.kernel.org
Cc: tboot-devel@lists.sourceforge.net, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.1.21.183017
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1700_1799 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, FROM_EDU_TLD 0, WEBMAIL_SOURCE 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HELO_GMAIL 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_HTTP_RECEIVED 0, __PHISH_SPEAR_STRUCTURE_1 0, __PHISH_SPEAR_STRUCTURE_2 0, __RDNS_GMAIL 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __TO_NO_NAME 0, __URI_NO_PATH 0, __URI_NO_WWW 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the documentation slightly more explicit about how to
enable Intel TXT support in the kernel, and adds two dependencies to
the relevant option in Kconfig.  Without this patch it is difficult to
determine how to enable Intel TXT support without some knowledge of
Kconfig.

Signed-off-by: Jonathan McCune <jonmccune@cmu.edu>

---
 Documentation/intel_txt.txt |    4 +++-
 security/Kconfig            |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/intel_txt.txt b/Documentation/intel_txt.txt
index 849de1a..8487f76 100644
--- a/Documentation/intel_txt.txt
+++ b/Documentation/intel_txt.txt
@@ -196,7 +196,9 @@ Execution Technology (TXT)".  It is marked as
EXPERIMENTAL and
 depends on the generic x86 support (to allow maximum flexibility in
 kernel build options), since the tboot code will detect whether the
 platform actually supports Intel TXT and thus whether any of the
-kernel code is executed.
+kernel code is executed. The kernel option for enabling Intel TXT
+support will only appear if its dependencies are also enabled.
+These are CONFIG_DMAR and CONFIG_PCI_MSI.

 The Q35_SINIT_17.BIN file is what Intel TXT refers to as an
 Authenticated Code Module.  It is specific to the chipset in the
diff --git a/security/Kconfig b/security/Kconfig
index 95accd4..5fd4e35 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -136,7 +136,7 @@ config SECURITY_PATH

 config INTEL_TXT
 	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
-	depends on HAVE_INTEL_TXT
+	depends on HAVE_INTEL_TXT && EXPERIMENTAL && DMAR && ACPI
 	help
 	  This option enables support for booting the kernel with the
 	  Trusted Boot (tboot) module. This will utilize
-- 
1.5.6.5
