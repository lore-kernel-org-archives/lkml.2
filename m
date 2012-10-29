Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab2J2InJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:43:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7860 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab2J2InG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:43:06 -0400
X-IronPort-AV: E=Sophos;i="4.80,670,1344182400"; 
   d="scan'208";a="6091103"
From: Wen Congyang <wency@cn.fujitsu.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, bhelgaas@google.com,
        "H. Peter Anvin" <hpa@zytor.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v3 1/2] update mem= option's spec according to its implementation
Date: Mon, 29 Oct 2012 16:48:43 +0800
Message-Id: <1351500524-23907-2-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351500524-23907-1-git-send-email-wency@cn.fujitsu.com>
References: <1351500524-23907-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 16:42:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 16:42:23,
	Serialize complete at 2012/10/29 16:42:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current mem= implementation seems buggy because specification and
implementation doesn't match. Current mem= has been working
for many years and it's not buggy, it works as expected. So
we should update the specification.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Sort-of-tentatively-acked-by: Rob Landley <rob@landley.net>
---
 Documentation/kernel-parameters.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..91863a5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1481,9 +1481,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
 			Amount of memory to be used when the kernel is not able
 			to see the whole system memory or for test.
-			[X86-32] Use together with memmap= to avoid physical
-			address space collisions. Without memmap= PCI devices
-			could be placed at addresses belonging to unused RAM.
+			[X86] Work as limiting max address. Use together
+			with memmap= to avoid physical address space collisions.
+			Without memmap= PCI devices could be placed at addresses
+			belonging to unused RAM.
 
 	mem=nopentium	[BUGS=X86-32] Disable usage of 4MB pages for kernel
 			memory.
-- 
1.8.0

