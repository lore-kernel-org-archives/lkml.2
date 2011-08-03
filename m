Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab1HCNct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:32:49 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:53737 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683Ab1HCNcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:32:14 -0400
X-AuditID: 12074422-b7ba7ae000000a14-2f-4e394dccd507
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 1/6] x86-64: Pad vDSO to a page boundary
Date: Wed,  3 Aug 2011 09:31:49 -0400
Message-Id: <a63380a3c58a0506a2f5a18ba1b12dbde1f25e58.1312378163.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsUixG6nonvG19LPYNVOIYu+K0fZLR7Ne8Rq
	MXXZXFaLZYufMlpc3jWHzWL52XlsFj82PGa1uDflPbsDh8fOWXfZPTZfXM3ksWlVJ5vH5BvL
	GT229+1i9/j49BaLx+dNcgHsUVw2Kak5mWWpRfp2CVwZ+6bNZCzoZqnoaNnK2sC4irmLkYND
	QsBEYvaJ5C5GTiBTTOLCvfVsXYxcHEIC+xglPp49xgrhrGeUmHvrDTOE85RJ4varDawgLWwC
	KhIdSx8wgdgiAk4SrRM+MoEUMQs8Y5TYdPQMM0hCWMBa4tnyZjCbRUBV4srzE+wgNq9AkMS/
	VeeZIXbLSRy5/BxsEKeAgcSqBc9ZQM4TEtCXeLAmH4fwBEaBBYwMqxhlU3KrdHMTM3OKU5N1
	i5MT8/JSi3RN9XIzS/RSU0o3MYJD2UVpB+PPg0qHGAU4GJV4eBnkLfyEWBPLiitzDzFKcjAp
	ifIu97L0E+JLyk+pzEgszogvKs1JLT7EKMHBrCTC284LlONNSaysSi3Kh0lJc7AoifOWeP/3
	FRJITyxJzU5NLUgtgsnKcHAoSfB6AWNWSLAoNT21Ii0zpwQhzcTBCTKcB2i4DUgNb3FBYm5x
	ZjpE/hSjopQ4ryFIQgAkkVGaB9cLSzWvGMWBXhHmtQWp4gGmKbjuV0CDmYAG/39vATK4JBEh
	JdXAGMSSHaDFysafbCoxc8e8c65BQqtqL5w8Zc+pszjxg0t/oHjkop5d+29H/n/1dEm3yQXZ
	7TUfRDPnPTyod4V9ql6l8PP8m1cvtt1elxc838oqWf/cRoOH8nyzvshf5ZSyvrh/kvHn/59V
	j2+yErx7h+f4h9nhD/7nHverS7rzY8bLmwcYHsiWaSqxFGckGmoxFxUnAgCS7+1rEAMAAA==
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

