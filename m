Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2HVP7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab2HVP7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:59:11 -0400
Date: Wed, 22 Aug 2012 17:55:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        peterz@infradead.org, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, michael@ellerman.id.au
Subject: Re: [PATCH v4 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120822155521.GA3993@redhat.com>
References: <20120822082205.GA29216@in.ibm.com> <20120822082708.GB29216@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822082708.GB29216@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Ananth N Mavinakayanahalli wrote:
>
> +int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
> +{
> +	unsigned int insn;
> +
> +	if (addr & 0x03)
> +		return -EINVAL;
> +
> +	memcpy(&insn, auprobe->insn, MAX_UINSN_BYTES);
> +	if (is_trap(insn))
> +		return -ENOTSUPP;

This addresses the only concern I had, thanks.

Once again, I am in no position to review the powerpc code, but
since I made some noise before: I think the patch is fine.

Oleg.

