Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2KSFcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:32:51 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43720 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab2KSFct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:32:49 -0500
X-Originating-IP: 217.70.178.143
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        konrad.wilk@oracle.com, Attilio Rao <attilio.rao@citrix.com>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 49/58] x86: init: Mark internal functions iommu_init_noop and iommu_shutdown_noop static
Date: Sun, 18 Nov 2012 21:28:28 -0800
Message-Id: <1353302917-13995-50-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of arch/x86/kernel/x86_init.c references iommu_init_noop
or iommu_shutdown_noop, so mark them static.  This eliminates warnings
from GCC (-Wmissing-prototypes) and Sparse (-Wdecl).

arch/x86/kernel/x86_init.c:29:115: warning: no previous prototype for ‘iommu_init_noop’ [-Wmissing-prototypes]
arch/x86/kernel/x86_init.c:30:6: warning: no previous prototype for ‘iommu_shutdown_noop’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/x86_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 7a3d075..28b2100 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -26,8 +26,8 @@
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
-int __init iommu_init_noop(void) { return 0; }
-void iommu_shutdown_noop(void) { }
+static int __init iommu_init_noop(void) { return 0; }
+static void iommu_shutdown_noop(void) { }
 
 /*
  * The platform setup functions are preset with the default functions
-- 
1.7.10.4

