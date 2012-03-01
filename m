Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab2CAIeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:34:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:19029 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758661Ab2CAIeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:34:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123588103"
Subject: change last level cache alignment on x86?
From: "Alex,Shi" <alex.shi@intel.com>
To: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, asit.k.mallick@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Mar 2012 16:33:36 +0800
Message-ID: <1330590816.21053.1336.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently last level defined in kernel is still 128 bytes, but actually
I checked intel's core2, NHM, SNB, atom, serial platforms, all of them
are using 64 bytes. 
I did not get detailed info on AMD platforms. Guess someone like to give
the info here. So, Is if it possible to do the similar following changes
to use 64 byte cache alignment in kernel?

===
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 3c57033..f342a5a 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -303,7 +303,7 @@ config X86_GENERIC
 config X86_INTERNODE_CACHE_SHIFT
 	int
 	default "12" if X86_VSMP
-	default "7" if NUMA
+	default "7" if NUMA && (MPENTIUM4)
 	default X86_L1_CACHE_SHIFT
 
 config X86_CMPXCHG


