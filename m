Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab2JSQ2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:28:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:51696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2JSQ2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:28:41 -0400
Message-ID: <1350664077.2768.32.camel@twins>
Subject: Re: [PATCH 2/2] perf: SNB exclusive PMU access for
 INST_RETIRED:PREC_DIST
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com
Date: Fri, 19 Oct 2012 18:27:57 +0200
In-Reply-To: <1350658326-14715-3-git-send-email-eranian@google.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
	 <1350658326-14715-3-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 16:52 +0200, Stephane Eranian wrote:
> +static int intel_pebs_aliases_snb(struct perf_event *event)
> +{
> +       u64 cfg = event->hw.config;
> +       /*
> +        * for INST_RETIRED.PREC_DIST to work correctly with PEBS, it must
> +        * be measured alone on SNB (exclusive PMU access) as per Intel SDM.
> +        */
> +       if ((cfg & INTEL_ARCH_EVENT_MASK) == 0x01c0 && !event->attr.exclusive) {
> +               pr_info("perf: INST_RETIRED.PREC_DIST only works in exclusive mode\n");
> +               return -EINVAL;

This isn't limited to admin, right? So the above turns into a DoS on the
console.

> +       }
> +
> +       return intel_pebs_aliases_ivb(event);
>  } 
