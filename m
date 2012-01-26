Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab2AZNpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:45:51 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44756 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2AZNpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:45:50 -0500
X-AuditID: b753bd60-99794ba000007b1b-03-4f21590a5ec3
X-AuditID: b753bd60-99794ba000007b1b-03-4f21590a5ec3
Message-ID: <4F215901.5020602@hitachi.com>
Date: Thu, 26 Jan 2012 22:45:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 3.2 1/9] uprobes: Install and remove breakpoints.
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com> <20120110114831.17610.88468.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20120110114831.17610.88468.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/10 20:48), Srikar Dronamraju wrote:
> +static void handle_riprel_insn(struct mm_struct *mm, struct uprobe *uprobe,
> +							struct insn *insn)
> +{
> +	u8 *cursor;
> +	u8 reg;
> +
> +	if (mm->context.ia32_compat)
> +		return;
> +
> +	uprobe->arch_info.rip_rela_target_address = 0x0;
> +	if (!insn_rip_relative(insn))
> +		return;
> +
> +	/*
> +	 * Point cursor at the modrm byte.  The next 4 bytes are the
> +	 * displacement.  Beyond the displacement, for some instructions,
> +	 * is the immediate operand.
> +	 */
> +	cursor = uprobe->insn + insn->prefixes.nbytes
> +			+ insn->rex_prefix.nbytes + insn->opcode.nbytes;

FYI, insn.h already provide a macro for this purpose.
You can write this as below;

	cursor = uprobe->insn + insn_offset_modrm(insn);

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
