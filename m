Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab0HaHC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:02:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49701 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab0HaHCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=AqP8P8TaNYMpAenLl0xZKeGxBfI7FawpSWTL8whazZX/kF6vWCu6uNWkMn7K3YezTT
         H0wHRDTgxO3ULUzjI7ZNcZEwvL8ADUBkF/dZI4L7phMwD4k0FloUGO//QRDDNqJq2tPq
         7PAPqlOlS31GZi0nT/c50HrswdnCHzoXuBbSI=
Date: Tue, 31 Aug 2010 09:33:12 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, amd: Remove superfluous CPU family/model check
Message-ID: <20100831073312.GF4655@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

amd_fixup_dcm() already checks for existence of a CPUID flag, so there
is no point in further restricting this function to run only on
specific CPUs.

In particular this prevents amd_fixup_dcm() to be executed on future
AMD CPU families which might also be available as multi-node
processors. (IMHO this is good reason to tag this patch for stable
trees.)

Cc: stable@kernel.org [.32.x .34.x, .35.x]
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

Patch is against tip/master as of today
(v2.6.36-rc3-1233-gf3d0a67)

Please apply.


Thanks,
Andreas

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9fb3ab3..fcf9895 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -305,8 +305,7 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 	/* use socket ID also for last level cache */
 	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
 	/* fixup topology information on multi-node processors */
-	if ((c->x86 == 0x10) && (c->x86_model == 9))
-		amd_fixup_dcm(c);
+	amd_fixup_dcm(c);
 #endif
 }
 
-- 
1.6.4.4

