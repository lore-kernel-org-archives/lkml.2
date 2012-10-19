Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab2JSPuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:50:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:49424 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab2JSPt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:49:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,613,1344236400"; 
   d="scan'208";a="208160231"
Date: Fri, 19 Oct 2012 08:49:58 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com
Subject: Re: [PATCH 2/2] perf: SNB exclusive PMU access for
 INST_RETIRED:PREC_DIST
Message-ID: <20121019154958.GY2095@tassilo.jf.intel.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
 <1350658326-14715-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350658326-14715-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * for INST_RETIRED.PREC_DIST to work correctly with PEBS, it must
> +	 * be measured alone on SNB (exclusive PMU access) as per Intel SDM.
> +	 */
> +	if ((cfg & INTEL_ARCH_EVENT_MASK) == 0x01c0 && !event->attr.exclusive) {
> +		pr_info("perf: INST_RETIRED.PREC_DIST only works in exclusive mode\n");
> +		return -EINVAL;
> +	}


Strictly you have to check for precise too, right?

-Andi
