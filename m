Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1FCOmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:42:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54559 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1FCOmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:42:11 -0400
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to
 guests
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <1305129333-7456-6-git-send-email-avi@redhat.com>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
	 <1305129333-7456-6-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Jun 2011 16:41:53 +0200
Message-ID: <1307112113.2353.3391.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 11:55 -0400, Avi Kivity wrote:
> +static u64 read_gp_pmc(struct kvm_pmu *pmu, struct kvm_pmc *pmc)
> +{
> +       u64 counter, enabled, running;
> +
> +       counter = pmc->counter;
> +
> +       if (pmc->perf_event)
> +               counter += perf_event_read_value(pmc->perf_event,
> +                                                &enabled, &running);
> +
> +       /* FIXME: Scaling needed? */

Yeah, either that or use attr.pinned = 1, doing the latter will result
in an error when the PMU is overloaded though.

> +       return counter & pmu->counter_bitmask;
> +} 
