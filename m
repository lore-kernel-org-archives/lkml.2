Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2EHSXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:23:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:11241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab2EHSXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:23:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637025"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com
Subject: [PATCH 08/23] x86, realmode: Allow absolute pa_* symbols in the realmode code
Date: Tue,  8 May 2012 21:22:31 +0300
Message-Id: <1336501366-28617-9-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Allow pa_* symbols to be absolute (outside any section) in the
realmode linker script.  Some versions of GNU ld are known to be
unhappy about symbols defined in a section that is otherwise empty.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 scripts/x86-relocs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/x86-relocs.c b/scripts/x86-relocs.c
index 0291470..74e16bb 100644
--- a/scripts/x86-relocs.c
+++ b/scripts/x86-relocs.c
@@ -62,6 +62,13 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 
 static const char * const sym_regex_realmode[S_NSYMTYPES] = {
 /*
+ * These symbols are known to be relative, even if the linker marks them
+ * as absolute (typically defined outside any section in the linker script.)
+ */
+	[S_REL] =
+	"^pa_",
+
+/*
  * These are 16-bit segment symbols when compiling 16-bit code.
  */
 	[S_SEG] =
-- 
1.7.9.5

