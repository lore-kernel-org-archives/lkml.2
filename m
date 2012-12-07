Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031007Ab2LGXDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:03:08 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63976 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2LGXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:03:07 -0500
Date: Fri, 7 Dec 2012 23:03:03 +0000
From: Cong Ding <dinggnu@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/tools/gen-insn-attr-x86.awk: remove duplicate
 const
Message-ID: <20121207230302.GB6179@gmail.com>
References: <1354920151-4461-1-git-send-email-dinggnu@gmail.com>
 <3c1e54bc-31ec-4a38-b6d3-58b25760f9cb@email.android.com>
 <20121207224949.GA6179@gmail.com>
 <50C27410.7050101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C27410.7050101@zytor.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:56:16PM -0800, H. Peter Anvin wrote:
> On 12/07/2012 02:49 PM, Cong Ding wrote:
> >On Fri, Dec 07, 2012 at 02:45:43PM -0800, H. Peter Anvin wrote:
> >>Patch description please?
> >there are 2 consts in the definition of one variable
> >
> 
> Please put in an actual patch description.  The first line (subject
> line) is a title; the patch should make sense without it.
sorry for that. so like this is fine?

-cong

---
>From 1abfab824ed2dc0af6e283ea0b7a6c45541d4fd1 Mon Sep 17 00:00:00 2001
From: Cong Ding <dinggnu@gmail.com>
Date: Fri, 7 Dec 2012 22:41:09 +0000
Subject: [PATCH] arch/x86/tools/gen-insn-attr-x86.awk: remove duplicate const

there are two const in the definition of one variable, we should delete one.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/x86/tools/gen-insn-attr-x86.awk |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index ddcf39b..d1d9cfa 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -356,7 +356,7 @@ END {
 		exit 1
 	# print escape opcode map's array
 	print "/* Escape opcode map array */"
-	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1]" \
+	print "const insn_attr_t *inat_escape_tables[INAT_ESC_MAX + 1]" \
 	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < geid; i++)
 		for (j = 0; j < max_lprefix; j++)
@@ -365,7 +365,7 @@ END {
 	print "};\n"
 	# print group opcode map's array
 	print "/* Group opcode map array */"
-	print "const insn_attr_t const *inat_group_tables[INAT_GRP_MAX + 1]"\
+	print "const insn_attr_t *inat_group_tables[INAT_GRP_MAX + 1]"\
 	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < ggid; i++)
 		for (j = 0; j < max_lprefix; j++)
-- 
1.7.4.5

