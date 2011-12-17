Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1LQVpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 16:45:21 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34604 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1LQVpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 16:45:19 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] apb: Fix configuration constraints
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Sat, 17 Dec 2011 21:57:25 +0000
Message-ID: <20111217215719.3743.93550.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The APB timer requires SFI, SCU and MID support

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13947a2..ea425d0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -716,6 +716,7 @@ config APB_TIMER
        def_bool y if X86_INTEL_MID
        prompt "Intel MID APB Timer Support" if X86_INTEL_MID
        select DW_APB_TIMER
+       depends on X86_INTEL_MID && SFI
        help
          APB timer is the replacement for 8254, HPET on X86 MID platforms.
          The APBT provides a stable time base on SMP

