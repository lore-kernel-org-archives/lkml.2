Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab0GTS7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 14:59:33 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:52517 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0GTS6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 14:58:16 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5VE0V-01-LM3-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/10] x86, xsave: do not include asm/i387.h in asm/xsave.h
Date: Tue, 20 Jul 2010 20:50:48 +0200
Message-ID: <1279651857-24639-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no dependencies to asm/i387.h. Instead, if including only
xsave.h the following error occurs:

 .../arch/x86/include/asm/i387.h:110: error: ‘XSTATE_FP’ undeclared (first use in this function)
 .../arch/x86/include/asm/i387.h:110: error: (Each undeclared identifier is reported only once
 .../arch/x86/include/asm/i387.h:110: error: for each function it appears in.)

This patch fixes this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/xsave.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index ec86c5f..94d5f84 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 #include <asm/processor.h>
-#include <asm/i387.h>
 
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
-- 
1.7.1.1


