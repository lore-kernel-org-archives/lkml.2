Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0EKMAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 08:00:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39144 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0EKMAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 08:00:43 -0400
Message-ID: <4BE946E8.2000007@canonical.com>
Date: Tue, 11 May 2010 14:00:40 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       stable-review@kernel.org,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [98/98] MIPS: uasm: Add OR instruction.
References: <20100510223543.205125755@kvm.kroah.org> <4BE94543.3030204@canonical.com>
In-Reply-To: <4BE94543.3030204@canonical.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------060406020201000402080904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060406020201000402080904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached a quick backport on it.


--------------060406020201000402080904
Content-Type: text/x-diff;
 name="0001-MIPS-uasm-Add-OR-instruction.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-MIPS-uasm-Add-OR-instruction.patch"

>From b0d6c56422165599c14e8cc10070f0ffbcf858ab Mon Sep 17 00:00:00 2001
From: Ralf Baechle <ralf@linux-mips.org>
Date: Fri, 23 Apr 2010 02:56:39 +0100
Subject: [PATCH] MIPS: uasm: Add OR instruction.

(cherry picked from commit 9c6befe8c744fa2f03cab36dead503c77950c3b8)

This is needed for the fix of the M3 workaround.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/mips/mm/uasm.c |    4 +++-
 arch/mips/mm/uasm.h |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/mips/mm/uasm.c b/arch/mips/mm/uasm.c
index f467199..e1bd527 100644
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
@@ -116,6 +116,7 @@ static struct insn insn_table[] __cpuinitdata = {
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
diff --git a/arch/mips/mm/uasm.h b/arch/mips/mm/uasm.h
index c6d1e3d..5198ae5 100644
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
-- 
1.7.0.4


--------------060406020201000402080904--
