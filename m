Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0FHIcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:32:07 -0400
Received: from daytona.panasas.com ([67.152.220.89]:61185 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751533Ab0FHIcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:32:03 -0400
Message-ID: <4C0DFFFF.1010704@panasas.com>
Date: Tue, 08 Jun 2010 11:31:59 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kbuild: Fix the breakage caused by "improve version string logic"
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 08:32:02.0158 (UTC) FILETIME=[1187C8E0:01CB06E5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patch: 85a256d8e0116c8f5ad276730830f5d4d473344d
	Author: David Rientjes <rientjes@google.com>
	Title: kbuild: improve version string logic

Broke none Linus trees that supply their own version string and
tag system via a presence of a localversion* file at the Kernel's
root subdirectory.

After This patch. The "+" (plus) is not added if a localversion*
file is present or a CONFIG_LOCALVERSION is configured.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 654c31a..324a413 100644
--- a/Makefile
+++ b/Makefile
@@ -945,7 +945,9 @@ ifdef CONFIG_LOCALVERSION_AUTO
 else
 	ifneq ($(scm-identifier),)
 		ifeq ($(LOCALVERSION),)
-			localver-extra = +
+			ifeq ($(localver),)
+				localver-extra = +
+			endif
 		endif
 	endif
 endif
-- 
1.6.6.1

