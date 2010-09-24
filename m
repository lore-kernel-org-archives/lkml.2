Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab0IXQgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:36:07 -0400
Received: from kroah.org ([198.145.64.141]:37462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab0IXQf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:59 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:49 2010
Message-Id: <20100924163349.517884639@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [62/68] [PATCH] MIPS: uasm: Add OR instruction.
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 5808184f1b2fe06ef8a54a2b7fb1596d58098acf upstream.

This is needed for the fix of the M3 workaround.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
[Backported by Aurelien Jarno <aurelien@aurel32.net>]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/mm/uasm.c |    4 +++-
 arch/mips/mm/uasm.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/mips/mm/uasm.c
+++ b/arch/mips/mm/uasm.c
@@ -62,7 +62,7 @@ enum opcode {
 	insn_dmtc0, insn_dsll, insn_dsll32, insn_dsra, insn_dsrl,
 	insn_dsrl32, insn_dsubu, insn_eret, insn_j, insn_jal, insn_jr,
 	insn_ld, insn_ll, insn_lld, insn_lui, insn_lw, insn_mfc0,
-	insn_mtc0, insn_ori, insn_pref, insn_rfe, insn_sc, insn_scd,
+	insn_mtc0, insn_or, insn_ori, insn_pref, insn_rfe, insn_sc, insn_scd,
 	insn_sd, insn_sll, insn_sra, insn_srl, insn_subu, insn_sw,
 	insn_tlbp, insn_tlbwi, insn_tlbwr, insn_xor, insn_xori
 };
@@ -116,6 +116,7 @@ static struct insn insn_table[] __cpuini
 	{ insn_lw,  M(lw_op, 0, 0, 0, 0, 0),  RS | RT | SIMM },
 	{ insn_mfc0,  M(cop0_op, mfc_op, 0, 0, 0, 0),  RT | RD | SET},
 	{ insn_mtc0,  M(cop0_op, mtc_op, 0, 0, 0, 0),  RT | RD | SET},
+	{ insn_or,  M(spec_op, 0, 0, 0, 0, or_op),  RS | RT | RD },
 	{ insn_ori,  M(ori_op, 0, 0, 0, 0, 0),  RS | RT | UIMM },
 	{ insn_pref,  M(pref_op, 0, 0, 0, 0, 0),  RS | RT | SIMM },
 	{ insn_rfe,  M(cop0_op, cop_op, 0, 0, 0, rfe_op),  0 },
@@ -362,6 +363,7 @@ I_u2s3u1(_lw)
 I_u1u2u3(_mfc0)
 I_u1u2u3(_mtc0)
 I_u2u1u3(_ori)
+I_u3u1u2(_or)
 I_u2s3u1(_pref)
 I_0(_rfe)
 I_u2s3u1(_sc)
--- a/arch/mips/mm/uasm.h
+++ b/arch/mips/mm/uasm.h
@@ -78,6 +78,7 @@ Ip_u2s3u1(_lw);
 Ip_u1u2u3(_mfc0);
 Ip_u1u2u3(_mtc0);
 Ip_u2u1u3(_ori);
+Ip_u3u1u2(_or);
 Ip_u2s3u1(_pref);
 Ip_0(_rfe);
 Ip_u2s3u1(_sc);


