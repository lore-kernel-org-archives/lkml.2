Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2EHSXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:23:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:11241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab2EHSXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:23:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637048"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com
Subject: [PATCH 09/23] x86, realmode: Add .text64 section, make barrier symbols absolute
Date: Tue,  8 May 2012 21:22:32 +0300
Message-Id: <1336501366-28617-10-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Add a .text64 section.  The purpose of this is to keep 16-, 32- and
64-bit code segregated into separate sections, mainly to keep
disassembly sane.

Move barrier symbols out of sections to avoid the "symbol in empty
section" problem in some versions of GNU ld.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/realmode/rm/realmode.lds.S |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/realmode/rm/realmode.lds.S b/arch/x86/realmode/rm/realmode.lds.S
index 91b83ea..4d4afca 100644
--- a/arch/x86/realmode/rm/realmode.lds.S
+++ b/arch/x86/realmode/rm/realmode.lds.S
@@ -32,8 +32,8 @@ SECTIONS
 	}
 
 	. = ALIGN(PAGE_SIZE);
+	pa_text_start = .;
 	.text : {
-		pa_text_start = .;
 		*(.text)
 		*(.text.*)
 	}
@@ -41,9 +41,14 @@ SECTIONS
 	.text32 : {
 		*(.text32)
 		*(.text32.*)
-		pa_ro_end = .;
 	}
 
+	.text64 : {
+		*(.text64)
+		*(.text64.*)
+	}
+	pa_ro_end = .;
+
 	. = ALIGN(PAGE_SIZE);
 	.data : {
 		*(.data)
@@ -59,8 +64,8 @@ SECTIONS
 	. = ALIGN(4);
 	.signature : {
 		*(.signature)
-		pa_end = .;
 	}
+	pa_end = .;
 
 	/DISCARD/ : {
 		*(.note*)
-- 
1.7.9.5

