Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0IUMAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:00:32 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58557 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab0IUMAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:00:31 -0400
Date: Tue, 21 Sep 2010 14:00:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86, CPUID: Correct operator precedence when
 generating mask
Message-ID: <20100921120027.GB15756@aftab>
References: <20100920140621.GA4920@aftab>
 <4C9779AF.8080303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9779AF.8080303@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, Sep 20, 2010 at 11:11:43AM -0400

> Since this is a non-manifest bug there really doesn't seem to be any
> reason to bother stable with it.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Tue Sep 21 13:56:59 CEST 2010
Subject: [PATCH] x86, CPUID: Correct operator precedence when generating mask

NEED_<cpufeature> masks used in the CPU feature testing macros are
cutoff at the last 5 bits to prevent overflow since the cpu feature
words are 32-bit-wide bitfields. Fix this for the PSE and PGE masks too.

This wasn't a real problem since the PSE and PGE bits are nicely < 31.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/required-features.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 6c7fc25..0df924d 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -53,8 +53,8 @@
 #define NEED_PSE	0
 #define NEED_PGE	0
 #else
-#define NEED_PSE	(1<<(X86_FEATURE_PSE) & 31)
-#define NEED_PGE	(1<<(X86_FEATURE_PGE) & 31)
+#define NEED_PSE	(1<<(X86_FEATURE_PSE & 31))
+#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
 #endif
 #define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
 #define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
-- 
1.7.1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
