Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab1FGTdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:33:08 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:62968 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430Ab1FGTdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:33:05 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-08-4dee7ce20474
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 3/5] x86-64: Add --no-undefined to vDSO build
Date: Tue,  7 Jun 2011 15:32:40 -0400
Message-Id: <720f2afeac4ceb7cf01ed65d0405101e3ef62f1a.1307474707.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307474707.git.luto@mit.edu>
References: <cover.1307474707.git.luto@mit.edu>
In-Reply-To: <cover.1307474707.git.luto@mit.edu>
References: <cover.1307474707.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsUixCmqrPuo5p2vwYLlyhZ9V46yW1zeNYfN
	YsulZlaLHxseszqweNxq+8PssXPWXXaPTas62Tw+b5ILYInisklJzcksSy3St0vgytj6cS9r
	wWPWim/nNrA1MD5m6WLk5JAQMJHYfP4kG4QtJnHh3nogm4tDSGAfo0TvoqNgRUIC6xklZp8L
	hLAPMUmsvm4CYrMJqEh0LH3A1MXIwSEiICSx9G4dSJhZIE1i7vVfYK3CArYSi1Z/YgexWQRU
	Jb7tPgO2i1cgSOLbo6PsIK0SAgoS51flg5icAgYS/27XgphCAvoSG74IYhedwCiwgJFhFaNs
	Sm6Vbm5iZk5xarJucXJiXl5qka6xXm5miV5qSukmRnDgSfLtYPx6UOkQowAHoxIPb0HIO18h
	1sSy4srcQ4ySHExKoryG1UAhvqT8lMqMxOKM+KLSnNTiQ4wSHMxKIrwzrr/1FeJNSaysSi3K
	h0lJc7AoifPOlFT3FRJITyxJzU5NLUgtgsnKcHAoSfCmAiNMSLAoNT21Ii0zpwQhzcTBCTKc
	B2j4a5DFvMUFibnFmekQ+VOMuhxbT7w9yCjEkpeflyolzssHMkgApCijNA9uDixhvGIUB3pL
	mDcRpIoHmGzgJr0CWsIEtOT0WZAPiksSEVJSDYz1a7tWnTqytFqC9dKH5IOLolZOct1rwVKv
	WGZdUfDFYI1xw/oj8m/m7ZVN4NxWHlzp2DC9vrb6fHn5bKNV5/SuTJj6UMbwstBiR/EtK3q8
	VgZ9DfNe0bWlwNbVOFSda5c33ywGhiP/jZPEa/NZ/Xt4nJw/Gl3J4o29OOXVPO0TPiccn69Y
	0anEUpyRaKjFXFScCAADezZl8wIAAA==
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
1.7.5.2

