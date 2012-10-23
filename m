Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2JWMCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:02:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:41043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2JWMCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:02:15 -0400
Message-ID: <1350993710.13456.8.camel@twins>
Subject: Re: [PATCH 03/34] perf, x86: Basic Haswell PEBS support v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Date: Tue, 23 Oct 2012 14:01:50 +0200
In-Reply-To: <1350602382-12771-4-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	 <1350602382-12771-4-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> +struct event_constraint intel_hsw_pebs_event_constraints[] = {
> +       INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
> +       INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
> +       INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
> +       INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
> +       INTEL_EVENT_CONSTRAINT(0x01c5, 0xf),  /* BR_MISP_RETIRED.CONDITIONAL */
> +       INTEL_EVENT_CONSTRAINT(0x04c5, 0xf),  /* BR_MISP_RETIRED.ALL_BRANCHES */
> +       INTEL_EVENT_CONSTRAINT(0x20c5, 0xf),  /* BR_MISP_RETIRED.NEAR_TAKEN */
> +       INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
> +       INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
> +       INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_STORES */
> +       INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
> +       INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
> +       INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_STORES */
> +       INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
> +       INTEL_UEVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
> +       INTEL_UEVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
> +       INTEL_UEVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
> +       INTEL_UEVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
> +       INTEL_UEVENT_CONSTRAINT(0x40d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
> +       INTEL_UEVENT_CONSTRAINT(0x01d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
> +       INTEL_UEVENT_CONSTRAINT(0x02d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
> +       INTEL_UEVENT_CONSTRAINT(0x02d3, 0xf), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM */
> +       INTEL_UEVENT_CONSTRAINT(0x04c8, 0xf), /* HLE_RETIRED.Abort */
> +       INTEL_UEVENT_CONSTRAINT(0x04c9, 0xf), /* RTM_RETIRED.Abort */
> +
> +       EVENT_CONSTRAINT_END
> +}; 

ISTR asking this before, but I cannot find an answer in the previous
threads just now.

Do things like the 0xd0 event really need all the UEVENT things spelled
out? And 0x22d0 (LOCK_STORES) still appears missing going by the pattern
in there.

Also, it looks like the 0xc5 things want to be UEVENT, the current EVENT
thing will mask the umask.
