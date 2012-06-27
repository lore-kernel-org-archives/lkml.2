Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2F0Jm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:42:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55718 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab2F0Jm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:42:58 -0400
Message-ID: <1340790167.10063.3.camel@twins>
Subject: Re: [PATCH 2/2] perf/x86: Uncore Filter support for SandyBridge-EP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 11:42:47 +0200
In-Reply-To: <1340780953-21130-2-git-send-email-zheng.z.yan@intel.com>
References: <1340780953-21130-1-git-send-email-zheng.z.yan@intel.com>
	 <1340780953-21130-2-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 15:09 +0800, Yan, Zheng wrote:
> +static void snbep_uncore_put_constraint(struct intel_uncore_box *box,
> +                                       struct perf_event *event)
> +{
> +       struct intel_uncore_extra_reg *er;
> +       struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
> +
> +       if (box->phys_id < 0 || !reg1->alloc)
> +               return;
> +
> +       er = &box->shared_regs[reg1->idx];
> +       atomic_sub(1, &er->ref);

We have atomic_dec() for this ;-)

> +       reg1->alloc = 0;
> +} 
