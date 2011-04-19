Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1DSVFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:05:17 -0400
Received: from kroah.org ([198.145.64.141]:39448 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab1DSVEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 14:03:24 2011
Message-Id: <20110419210324.794101717@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 14:02:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [24/26] x86, cpu: Fix regression in AMD errata checking code
In-Reply-To: <20110419210333.GA17417@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Hans Rosenfeld <hans.rosenfeld@amd.com>

commit 07a7795ca2e6e66d00b184efb46bd0e23d90d3fe upstream.

A bug in the family-model-stepping matching code caused the presence of
errata to go undetected when OSVW was not used. This causes hangs on
some K8 systems because the E400 workaround is not enabled.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
LKML-Reference: <1282141190-930137-1-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -687,7 +687,7 @@ bool cpu_has_amd_erratum(const int *erra
 	}
 
 	/* OSVW unavailable or ID unknown, match family-model-stepping range */
-	ms = (cpu->x86_model << 8) | cpu->x86_mask;
+	ms = (cpu->x86_model << 4) | cpu->x86_mask;
 	while ((range = *erratum++))
 		if ((cpu->x86 == AMD_MODEL_RANGE_FAMILY(range)) &&
 		    (ms >= AMD_MODEL_RANGE_START(range)) &&


