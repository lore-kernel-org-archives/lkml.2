Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1G0DVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:21:17 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:56094 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689Ab1G0DU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:20:59 -0400
X-AuditID: 12074425-b7bcaae000000a1b-1c-4e2f83f29cc0
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 1/5] x86-64: Pad vDSO to a page boundary
Date: Tue, 26 Jul 2011 23:20:35 -0400
Message-Id: <8a9c7b051547171afd88fc53a6416a001f76ec4a.1311736366.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
References: <cover.1311736366.git.luto@mit.edu>
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
References: <cover.1311736366.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsUixG6novupWd/P4PRUTou+K0fZLR7Ne8Rq
	MXXZXFaLZYufMlpc3jWHzWL52XlsFj82PGa1uDflPbsDh8fOWXfZPTZfXM3ksWlVJ5vH5BvL
	GT229+1i9/j49BaLx+dNcgHsUVw2Kak5mWWpRfp2CVwZ+6bNZCzoZqnoaNnK2sC4irmLkYND
	QsBEYv27qC5GTiBTTOLCvfVsXYxcHEIC+xgl2hddYIdwNjBKXDo8gRGkSkjgGZPEyZnhIDab
	gIpEx9IHTCC2iICTROuEj0wgDcwCzxglNh09wwySEBawkJi39gsbiM0ioCpxafFedhCbVyBI
	YsPjrewQq+Ukjlx+DjaIU8BAYu/GVmaIZfoS677cZcYlPoFRYAEjwypG2ZTcKt3cxMyc4tRk
	3eLkxLy81CJdC73czBK91JTSTYzgYHZR3cE44ZDSIUYBDkYlHt6Nkfp+QqyJZcWVuYcYJTmY
	lER5M4CxIMSXlJ9SmZFYnBFfVJqTWnyIUYKDWUmEd8d/PT8h3pTEyqrUonyYlDQHi5I4b4j3
	f18hgfTEktTs1NSC1CKYrAwHh5IEbxjIUMGi1PTUirTMnBKENBMHJ8hwHqDh3iA1vMUFibnF
	mekQ+VOMilLivFtBEgIgiYzSPLheWLJ5xSgO9Iow7xKQKh5gooLrfgU0mAnkah2wwSWJCCmp
	Bkbtwgm3ej7WRPu6vHtxQNKo/vf6ABPBjPvfbZm+HGA+dfGB+UwN/Zj5QT7ZGVMz9h95EzMt
	yGSxwLpu/RS7h1vnWteuyQnYsDfV8an6zXMSLq3tD9/kz7lg6DzhttZ5rlkHsrnf9HWcrVSO
	LA/QM5h4Pcf+gO+NC6v+rjzjm7Tu5stT/nrVmbZKLMUZiYZazEXFiQBldTt3EQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids an information leak to userspace.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/vdso.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index 1b979c1..01f5e3b 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -9,6 +9,7 @@ __PAGE_ALIGNED_DATA
 vdso_start:
 	.incbin "arch/x86/vdso/vdso.so"
 vdso_end:
+	.align PAGE_SIZE /* extra data here leaks to userspace. */
 
 .previous
 
-- 
1.7.6

