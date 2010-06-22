Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0FVG7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 02:59:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56974 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0FVG7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cCsXdedoPFhlcIc1QdXKRGuIiRPhPVilX+XCj/sPqFFTsCWfB2g6RNFMYDV1uepSN0
         eOo8jzLQ+k8serkikCvjWDMGDnUXeAV7RQC2jbNNdmrLi5wDBv31Ly626/Qg5xcxozi3
         aLaTapEqTpTp28b0aPB1EKCQMKMDdG+HTuPd0=
From: Sankar P <sankar.curiosity@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lethal@linux-sh.org, linux-sh@vger.kernel.org, lrodriguez@atheros.com,
       penberg@cs.helsinki.fi, catalin.marinas@arm.com, rnagarajan@novell.com,
       teheo@novell.com, linux-mm@kvack.org,
       Sankar P <sankar.curiosity@gmail.com>
Subject: [PATCH] mm: kmemleak: Change kmemleak default buffer size
Date: Tue, 22 Jun 2010 12:28:29 +0530
Message-Id: <1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com>
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we try to find the memory leaks in kernel that is
compiled with 'make defconfig', the default buffer size
seem to be inadequate. Change the buffer size from
400 to 1000, which is sufficient in most cases.

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
---
 arch/sh/configs/sh7785lcr_32bit_defconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
index 71f39c7..b02e5ae 100644
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig
+++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -1710,7 +1710,7 @@ CONFIG_SCHEDSTATS=y
 # CONFIG_DEBUG_OBJECTS is not set
 # CONFIG_DEBUG_SLAB is not set
 CONFIG_DEBUG_KMEMLEAK=y
-CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
+CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=1000
 # CONFIG_DEBUG_KMEMLEAK_TEST is not set
 CONFIG_DEBUG_PREEMPT=y
 # CONFIG_DEBUG_RT_MUTEXES is not set
-- 
1.6.4.2

