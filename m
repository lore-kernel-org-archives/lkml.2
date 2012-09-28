Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2I1JGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:06:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:57029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2I1JGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:06:23 -0400
Message-ID: <1348823145.3292.62.camel@twins>
Subject: Re: [PATCH 02/31] perf, x86: Basic Haswell PMU support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Date: Fri, 28 Sep 2012 11:05:45 +0200
In-Reply-To: <1348806696-31170-3-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
>  /*
> + * Also filter out TSX bits.
> + */
> +#define TSX_FIXED_EVENT_CONSTRAINT(c, n)       \
> +       EVENT_CONSTRAINT(c, (1ULL << (32+n)),   \
> +                        X86_RAW_EVENT_MASK|HSW_INTX|HSW_INTX_CHECKPOINTED)

How volatile are those bits? Will the re-appear in future chips or are
they prone to get re-assigned different semantics in future chips?

If they're 'stable' we might as well add then to FIXED_EVENT_CONSTRAINT,
its not like those bits would ever appear on previous hardware.
