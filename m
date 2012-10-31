Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2JaFvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:51:49 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53260 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2JaFvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:51:42 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-47-5090bc6b57e8
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        ming.m.lin@intel.com
Subject: Re: [Patch v1 07/10] perf tools: add mem access sampling core support
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-8-git-send-email-eranian@google.com>
Date: Wed, 31 Oct 2012 14:51:39 +0900
In-Reply-To: <1351523752-4215-8-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Mon, 29 Oct 2012 16:15:49 +0100")
Message-ID: <87ip9r5gus.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 16:15:49 +0100, Stephane Eranian wrote:
> This patch adds the sorting and histogram support
> functions to enable profiling of memory accesses.
>
> The following sorting orders are added:
>  - symbol_daddr: data address symbol (or raw address)
>  - dso_daddr: data address shared object
>  - cost: access cost
>  - locked: access uses locked transaction
>  - tlb : TLB access
>  - mem : memory level of the access (L1, L2, L3, RAM, ...)
>  - snoop: access snoop mode
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
[snip]
> +/* --sort daddr_sym */
> +static int64_t
> +sort__daddr_cmp(struct hist_entry *left, struct hist_entry *right)
> +{
> +	struct addr_map_symbol *l = &left->mem_info->daddr;
> +	struct addr_map_symbol *r = &right->mem_info->daddr;
> +
> +	return (int64_t)(r->addr - l->addr);
> +}

Doesn't it need to compare symbol (start address) if any, before doing
it with raw addresses?

Thanks,
Namhyung
