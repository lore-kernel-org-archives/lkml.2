Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3AETGL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 14:06:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab3AETGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 14:06:09 -0500
Date: Sat, 5 Jan 2013 20:05:52 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v4 07/18] perf: add generic memory sampling interface
Message-ID: <20130105190552.GC995@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
 <1356018108-6081-8-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356018108-6081-8-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 04:41:37PM +0100, Stephane Eranian wrote:
> This patch adds PERF_SAMPLE_COST and PERF_SAMPLE_DSRC.
> The first collects a cost associated with the sampled
> event. In case of memory access, the cost would be
> the latency of the load, otherwise it defaults to
> the sampling period.
> 
> PERF_SAMPLE_DSRC collects the data source, i.e., where
> did the data associated with the sampled instruction
> come from. Information is stored in a perf_mem_dsrc
> structure. It contains opcode, mem level, tlb, snoop,
> lock information, subject to availability in hardware.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

SNIP

> +
> +/* type of opcode (load/store/prefetch,code) */
> +#define PERF_MEM_OP_NA		0x01 /* not available */
> +#define PERF_MEM_OP_LOAD	0x02 /* load instruction */
> +#define PERF_MEM_OP_STORE	0x04 /* store instruction */
> +#define PERF_MEM_OP_PFETCH	0x08 /* prefetch */
> +#define PERF_MEM_OP_EXEC	0x10 /* code (execution) */
> +#define PERF_MEM_OP_SHIFT	0
> +
> +/* memory hierarchy (memory level, hit or miss) */
> +#define PERF_MEM_LVL_NA		0x01  /* not available */
> +#define PERF_MEM_LVL_HIT	0x02  /* hit level */
> +#define PERF_MEM_LVL_MISS	0x04  /* miss level  */
> +#define PERF_MEM_LVL_L1		0x08  /* L1 */
> +#define PERF_MEM_LVL_LFB	0x10  /* Line Fill Buffer */
> +#define PERF_MEM_LVL_L2		0x20  /* L2 hit */
> +#define PERF_MEM_LVL_L3		0x40  /* L3 hit */
> +#define PERF_MEM_LVL_LOC_RAM	0x80  /* Local DRAM */
> +#define PERF_MEM_LVL_REM_RAM1	0x100 /* Remote DRAM (1 hop) */
> +#define PERF_MEM_LVL_REM_RAM2	0x200 /* Remote DRAM (2 hops) */
> +#define PERF_MEM_LVL_REM_CCE1	0x400 /* Remote Cache (1 hop) */
> +#define PERF_MEM_LVL_REM_CCE2	0x800 /* Remote Cache (2 hops) */
> +#define PERF_MEM_LVL_IO		0x1000 /* I/O memory */
> +#define PERF_MEM_LVL_UNC	0x2000 /* Uncached memory */
> +#define PERF_MEM_LVL_SHIFT	5
> +
> +/* snoop mode */
> +#define PERF_MEM_SNOOP_NA	0x01 /* not available */
> +#define PERF_MEM_SNOOP_NONE	0x02 /* no snoop */
> +#define PERF_MEM_SNOOP_HIT	0x04 /* snoop hit */
> +#define PERF_MEM_SNOOP_MISS	0x08 /* snoop miss */
> +#define PERF_MEM_SNOOP_HITM	0x10 /* snoop hit modified */
> +#define PERF_MEM_SNOOP_SHIFT	19
> +
> +/* locked instruction */
> +#define PERF_MEM_LOCK_NA	0x01 /* not available */
> +#define PERF_MEM_LOCK_LOCKED	0x02 /* locked transaction */
> +#define PERF_MEM_LOCK_SHIFT	24
> +
> +/* TLB access */
> +#define PERF_MEM_TLB_NA		0x01 /* not available */
> +#define PERF_MEM_TLB_HIT	0x02 /* hit level */
> +#define PERF_MEM_TLB_MISS	0x04 /* miss level */
> +#define PERF_MEM_TLB_L1		0x08 /* L1 */
> +#define PERF_MEM_TLB_L2		0x10 /* L2 */
> +#define PERF_MEM_TLB_WK		0x20 /* Hardware Walker*/
> +#define PERF_MEM_TLB_OS		0x40 /* OS fault handler */
> +#define PERF_MEM_TLB_SHIFT	26
> +
> +#define PERF_MEM_S(a, s) \
> +	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)

Why dont use enums for this?

jirka
