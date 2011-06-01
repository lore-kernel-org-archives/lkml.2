Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162536Ab1FAJHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:07:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:43947 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161950Ab1FAIQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:16:28 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:10:58 2011
Message-Id: <20110601081057.575121858@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:46 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [016/165] x86, cpufeature: Fix cpuid leaf 7 feature detection
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 947
Lines: 30

From: Fenghua Yu <fenghua.yu@intel.com>

commit 2494b030ba9334c7dd7df9b9f7abe4eacc950ec5 upstream.

CPUID leaf 7, subleaf 0 returns the maximum subleaf in EAX, not the
number of subleaves.  Since so far only subleaf 0 is defined (and only
the EBX bitfield) we do not need to qualify the test.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1305660806-17519-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/common.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -565,8 +565,7 @@ void __cpuinit get_cpu_cap(struct cpuinf
 
 		cpuid_count(0x00000007, 0, &eax, &ebx, &ecx, &edx);
 
-		if (eax > 0)
-			c->x86_capability[9] = ebx;
+		c->x86_capability[9] = ebx;
 	}
 
 	/* AMD-defined flags: level 0x80000001 */


