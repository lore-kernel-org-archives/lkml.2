Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1GMN0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:26:00 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:46791 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770Ab1GMNYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:24:30 -0400
X-AuditID: 12074425-b7bcaae000000a1b-87-4e1d9c647f24
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 4/8] x86-64: Add --no-undefined to vDSO build
Date: Wed, 13 Jul 2011 09:24:12 -0400
Message-Id: <de0b50920469ff6359c529526e7639fdd36fa83c.1310563276.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310563276.git.luto@mit.edu>
References: <cover.1310563276.git.luto@mit.edu>
In-Reply-To: <cover.1310563276.git.luto@mit.edu>
References: <cover.1310563276.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsUixG6nopsyR9bPYNk2U4u+K0fZLS42bmOx
	aF07n93i8q45bBZbLjWzWmw68ZvR4seGx6wO7B7djz4xetxq+8PssXPWXXaPTas62TzOXetj
	9vi8SS6ALYrLJiU1J7MstUjfLoErY8aTBvaCh6wVdxZZNTA+ZOli5OSQEDCROLCmkxXCFpO4
	cG89WxcjF4eQwD5GiZYFr9ghnA2MEtN+/WeEcJ4xSfw+PJUZpIVNQEWiY+kDpi5GDg4RASGJ
	pXfrQMLMAk8YJSbs1QexhQUcJI4sPQ1WwiKgKrFrryVImFcgSOL47T/sEIvlJI5cfs4EYnMK
	GEjMWXADLC4koC/xvOMwMy7xCYwCCxgZVjHKpuRW6eYmZuYUpybrFicn5uWlFula6OVmluil
	ppRuYgQHrYvqDsYJh5QOMQpwMCrx8ErEy/gJsSaWFVfmHmKU5GBSEuVVnS3rJ8SXlJ9SmZFY
	nBFfVJqTWnyIUYKDWUmEt74BKMebklhZlVqUD5OS5mBREucN8f7vKySQnliSmp2aWpBaBJOV
	4eBQkuC9ATJUsCg1PbUiLTOnBCHNxMEJMpwHaPgskBre4oLE3OLMdIj8KUZdjlNnFhxhFGLJ
	y89LlRLn3QBSJABSlFGaBzcHlmxeMYoDvSXMexSkigeYqOAmvQJawgS0ZJ0V2JKSRISUVAPj
	ntPOWvpM8nMOPv/TNJtzWoQXS7tY58VJX76kzdiuI3fRVy88TKz42SrGpd56x/5qZjW8u7nb
	wpV5qpDmutuP3aRbDFbW7N2h2rhYd/eTU5tPnotZplqxOljfYseDE3YvHv5wese7O9vIprNC
	uNg7MLWzd0GHV73yrH3pR6SelhrK/fS1vqmkxFKckWioxVxUnAgAO8bXLxEDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gives much nicer diagnostics when something goes wrong.  It's
supported at least as far back as binutils 2.15.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index bef0bc9..5d17950 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -26,6 +26,7 @@ targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 export CPPFLAGS_vdso.lds += -P -C
 
 VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
+			-Wl,--no-undefined \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
-- 
1.7.6

