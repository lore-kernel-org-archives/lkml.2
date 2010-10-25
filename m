Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0JYPwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:52:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33306 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab0JYPww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I4ZLCM5hmYpdzm8B+yohJdsAvM+j4+dO7OhWGjcsDS9JImBtEgFkZHM8+//HgHtt2H
         HA9Wn9Nt1lU+yygdFSKSCh1Iv/LfpRcsZ2dDOvaYRDQSRwr9fgRGCF+riA1DuwMi/RQX
         3Ef+jescC79n6qHXEG2uPAZlrUSBzZOSEnHLs=
From: Namhyung Kim <namhyung@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] sparc32: remove CONFIG_HAVE_PERF_EVENTS option
Date: Tue, 26 Oct 2010 00:52:37 +0900
Message-Id: <1288021958-3130-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288021958-3130-1-git-send-email-namhyung@gmail.com>
References: <1288021958-3130-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove HAVE_PERF_EVENTS and PERF_USE_VMALLOC under config
SPARC because they're under SPARC64 too. Supporting
perf_event needs atomic64 operations but AFAIK sparc32
doesn't provide them, CMIIW. ;-) Also removes redundant
HAVE_IRQ_WORK line.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/sparc/Kconfig |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3e9d314..4db8bc0 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -27,8 +27,6 @@ config SPARC
 	select RTC_CLASS
 	select RTC_DRV_M48T59
 	select HAVE_IRQ_WORK
-	select HAVE_PERF_EVENTS
-	select PERF_USE_VMALLOC
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
@@ -55,7 +53,6 @@ config SPARC64
 	select RTC_DRV_BQ4802
 	select RTC_DRV_SUN4V
 	select RTC_DRV_STARFIRE
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 
-- 
1.7.0.4

