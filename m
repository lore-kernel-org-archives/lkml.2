Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2FMCBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 22:01:50 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43093 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab2FMCBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 22:01:47 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 02/15] ARM: etm: Don't limit tracing to only non-secure code.
Date: Tue, 12 Jun 2012 19:01:20 -0700
Message-Id: <1339552887-17204-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1339552887-17204-1-git-send-email-john.stultz@linaro.org>
References: <1339552887-17204-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061302-5806-0000-0000-0000162677D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

On some systems kernel code is considered secure, and this code
already limits tracing to the kernel text segment which results
in no trace data.

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
CC: Mathieu Poirier <mathieu.poirier@linaro.org>

Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/kernel/etm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index bd295e8..d7622f9 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -56,7 +56,7 @@ static inline bool trace_isrunning(struct tracectx *t)
 static int etm_setup_address_range(struct tracectx *t, int n,
 		unsigned long start, unsigned long end, int exclude, int data)
 {
-	u32 flags = ETMAAT_ARM | ETMAAT_IGNCONTEXTID | ETMAAT_NSONLY | \
+	u32 flags = ETMAAT_ARM | ETMAAT_IGNCONTEXTID | ETMAAT_IGNSECURITY |
 		    ETMAAT_NOVALCMP;
 
 	if (n < 1 || n > t->ncmppairs)
-- 
1.7.3.2.146.gca209

