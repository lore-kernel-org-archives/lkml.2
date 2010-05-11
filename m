Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab0EKLxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 07:53:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46915 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0EKLxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 07:53:43 -0400
Message-ID: <4BE94543.3030204@canonical.com>
Date: Tue, 11 May 2010 13:53:39 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [98/98] MIPS: uasm: Add OR instruction.
References: <20100510223543.205125755@kvm.kroah.org>
In-Reply-To: <20100510223543.205125755@kvm.kroah.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That seems to fail to apply to a 2.6.32.12 tree

Stefan

On 05/11/2010 12:35 AM, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> (cherry picked from commit 9c6befe8c744fa2f03cab36dead503c77950c3b8)
> 
> This is needed for the fix of the M3 workaround.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> --- a/arch/mips/include/asm/uasm.h
> +++ b/arch/mips/include/asm/uasm.h
> @@ -84,6 +84,7 @@ Ip_u2s3u1(_lw);
>  Ip_u1u2u3(_mfc0);
>  Ip_u1u2u3(_mtc0);
>  Ip_u2u1u3(_ori);
> +Ip_u3u1u2(_or);
>  Ip_u2s3u1(_pref);
>  Ip_0(_rfe);
>  Ip_u2s3u1(_sc);
> diff --git a/arch/mips/mm/uasm.c b/arch/mips/mm/uasm.c
> index e3ca0f7..29bbd10 100644
> --- a/arch/mips/mm/uasm.c
> +++ b/arch/mips/mm/uasm.c
> @@ -61,7 +61,7 @@ enum opcode {
>  	insn_dmtc0, insn_dsll, insn_dsll32, insn_dsra, insn_dsrl,
>  	insn_dsrl32, insn_drotr, insn_dsubu, insn_eret, insn_j, insn_jal,
>  	insn_jr, insn_ld, insn_ll, insn_lld, insn_lui, insn_lw, insn_mfc0,
> -	insn_mtc0, insn_ori, insn_pref, insn_rfe, insn_sc, insn_scd,
> +	insn_mtc0, insn_or, insn_ori, insn_pref, insn_rfe, insn_sc, insn_scd,
>  	insn_sd, insn_sll, insn_sra, insn_srl, insn_subu, insn_sw,
>  	insn_tlbp, insn_tlbwi, insn_tlbwr, insn_xor, insn_xori, insn_dins
>  };
> @@ -116,6 +116,7 @@ static struct insn insn_table[] __cpuinitdata = {
>  	{ insn_lw,  M(lw_op, 0, 0, 0, 0, 0),  RS | RT | SIMM },
>  	{ insn_mfc0,  M(cop0_op, mfc_op, 0, 0, 0, 0),  RT | RD | SET},
>  	{ insn_mtc0,  M(cop0_op, mtc_op, 0, 0, 0, 0),  RT | RD | SET},
> +	{ insn_or,  M(spec_op, 0, 0, 0, 0, or_op),  RS | RT | RD },
>  	{ insn_ori,  M(ori_op, 0, 0, 0, 0, 0),  RS | RT | UIMM },
>  	{ insn_pref,  M(pref_op, 0, 0, 0, 0, 0),  RS | RT | SIMM },
>  	{ insn_rfe,  M(cop0_op, cop_op, 0, 0, 0, rfe_op),  0 },
> @@ -370,6 +371,7 @@ I_u2s3u1(_lw)
>  I_u1u2u3(_mfc0)
>  I_u1u2u3(_mtc0)
>  I_u2u1u3(_ori)
> +I_u3u1u2(_or)
>  I_u2s3u1(_pref)
>  I_0(_rfe)
>  I_u2s3u1(_sc)

