Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0HKGhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 02:37:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59553 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab0HKGho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 02:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fpa1/OUqMP6umaIPDETvSibG3X/MSuMzGAwd0VWn3R/ESVJT76DFxNlc190Jsn3G+x
         KxpFb0Mfz0RZ/toPAlQAGgEzWS/caN3MgOGBWqYVRDfmIOhgcrZ2ilUYPXafIEOQbslC
         AuUnInj4mV2B4/UpSssv2lOS0Lq+Zg39U09l0=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: add a comment to __pa_symbol
Date: Wed, 11 Aug 2010 15:37:41 +0900
Message-Id: <1281508661-29507-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100810070555.GA16638@elte.hu>
References: <20100810070555.GA16638@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until all supported versions of gcc recognize -fno-strict-overflow, we should
keep the RELOC_HIDE magic on __pa_symbol(). Comment it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Suggested-by: Ingo Molnar <mingo@elte.hu>

---

 I hope I'm doing right. :-)

 arch/x86/include/asm/page.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 625c3f0..06cb6f3 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -37,6 +37,13 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 #define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
+/*
+ * we need __phys_reloc_hide() here because gcc may assume that there is no
+ * overflow during __pa() calculation and can optimize it unexpectedly.
+ * Newer versions of gcc provide -fno-strict-overflow switch to handle this
+ * case properly. Once all supported versions of gcc understand it, we can
+ * remove this Voodoo magic stuff.
+ */
 #define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
 
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
-- 
1.7.0.4

