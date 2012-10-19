Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab2JSKKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:10:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18723 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758514Ab2JSKKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:10:46 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6031094"
From: wency@cn.fujitsu.com
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, bhelgaas@google.com,
        hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, muneda.takahiro@jp.fujitsu.com,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [RESEND PATCH v2 1/2] update mem= option's spec according to its implementation
Date: Fri, 19 Oct 2012 18:16:16 +0800
Message-Id: <1350641777-19605-2-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1350641777-19605-1-git-send-email-wency@cn.fujitsu.com>
References: <1350641777-19605-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 18:10:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 18:10:21,
	Serialize complete at 2012/10/19 18:10:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

Current mem= implementation seems buggy because specification and
implementation doesn't match. Current mem= has been working
for many years and it's not buggy, it works as expected. So
we should update the specification.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Sort-of-tentatively-acked-by: Rob Landley <rob@landley.net>
---
 Documentation/kernel-parameters.txt |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..85b911a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1481,9 +1481,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
 			Amount of memory to be used when the kernel is not able
 			to see the whole system memory or for test.
-			[X86-32] Use together with memmap= to avoid physical
-			address space collisions. Without memmap= PCI devices
-			could be placed at addresses belonging to unused RAM.
+			[X86-32] Work as limiting max address. Use together
+			with memmap= to avoid physical address space collisions.
+			Without memmap= PCI devices could be placed at addresses
+			belonging to unused RAM.
 
 	mem=nopentium	[BUGS=X86-32] Disable usage of 4MB pages for kernel
 			memory.
-- 
1.7.1

