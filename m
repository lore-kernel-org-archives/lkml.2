Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0CXMlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:41:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54061 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755742Ab0CXMlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:41:23 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] x86: Add a platform_type helper
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Wed, 24 Mar 2010 12:14:44 +0000
Message-ID: <20100324121428.27881.96956.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various x86 drivers for embedded stuff will need to know the platform they
are running on to do runtime setup. Having them all grovelling around at
boot_params.hdr.hardware_subarch seems a bad idea, so export it as an
inline function that hides all the details of how the value arrives.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/include/asm/setup.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 86b1506..4008446 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -60,6 +60,12 @@ static inline void x86_mrst_early_setup(void) { }
  */
 extern struct boot_params boot_params;
 
+/* Isolate the internal knowledge from the generic callers */
+extern __inline int x86_platform_type(void)
+{
+	return boot_params.hdr.hardware_subarch;
+}
+
 /*
  * Do NOT EVER look at the BIOS memory size location.
  * It does not work on many machines.

