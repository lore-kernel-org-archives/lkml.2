Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1E0RjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:39:04 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:44269 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301Ab1E0RjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:39:01 -0400
X-AuditID: 12074423-b7babae000007c6b-cc-4ddfe1ab8f9e
From: Andy Lutomirski <luto@MIT.EDU>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 1/5] x86-64: Fix alignment of jiffies variable
Date: Fri, 27 May 2011 13:38:38 -0400
Message-Id: <0ea062d74a64a11c587deeee4ca7e9c396a0244f.1306517576.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
References: <cover.1306517576.git.luto@mit.edu>
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
References: <cover.1306517576.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsUixCmqrLv64X1fg44TuhZ9V46yW1zeNYfN
	YsulZlaLzZumMlv82PCY1YHV41bbH2aPnbPusntsWtXJ5vHu3Dl2j8+b5AJYo7hsUlJzMstS
	i/TtErgyPs9by1rwjrViwY129gbGPyxdjJwcEgImEq0357BD2GISF+6tZ+ti5OIQEtjHKLH8
	+S0WCGcDo8SDSe2MEM4zJonX/xtZQVrYBFQkOpY+YAKxRQTiJBpm/waLMws4SNx+fIQRxBYW
	sJNo77kDVsMioCrxsWcDWA2vQJDEu0nT2SBWK0hcuTIP7CROAQOJ6393gJ0kJKAv8f3iOjZc
	4hMYBRYwMqxilE3JrdLNTczMKU5N1i1OTszLSy3SNdPLzSzRS00p3cQICk52F+UdjH8OKh1i
	FOBgVOLh1Tp431eINbGsuDL3EKMkB5OSKK/fA6AQX1J+SmVGYnFGfFFpTmrxIUYJDmYlEV6T
	/UA53pTEyqrUonyYlDQHi5I471xJdV8hgfTEktTs1NSC1CKYrAwHh5IE72yQoYJFqempFWmZ
	OSUIaSYOTpDhPEDDp4HU8BYXJOYWZ6ZD5E8x6nI0rt1xkFGIJS8/L1VKnPcpSJEASFFGaR7c
	HFhSecUoDvSWMO9xkCoeYEKCm/QKaAkT0BKd33dBlpQkIqSkGhgZs72YD938trrwvI/rk0s3
	MzZcX/ho1aZnPyUNNmqVOopnS7B2JSy7L2ztoLJWsfOtZc8qmW3yRyIyk+19urY8UXFYqJ/5
	6poTo7+n24PLmrte62zKWml8y/zDIrnW8yE9fc6KOtvFpOsX/e69URd8gr++MmtZYmDjNg/V
	JZesPNY80/Gv1lFiKc5INNRiLipOBABb83keBQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's declared __attribute__((aligned(16)) but it's explicitly not
aligned.  This is probably harmless but it's a but embarrassing.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/vvar.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 341b355..a4eaca4 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -45,7 +45,7 @@
 /* DECLARE_VVAR(offset, type, name) */
 
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
-DECLARE_VVAR(8, int, vgetcpu_mode)
+DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
-- 
1.7.5.1

