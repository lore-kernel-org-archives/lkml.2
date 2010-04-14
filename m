Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0DNJuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:50:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58645 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0DNJuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:50:01 -0400
To: Salman <sqazi@google.com>
Cc: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org,
       csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Subject: Re: [PATCH 1/3] [kidled]: introduce kidled.
From: Andi Kleen <andi@firstfloor.org>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	<20100414000823.29004.98991.stgit@bumblebee1.mtv.corp.google.com>
Date: Wed, 14 Apr 2010 11:49:56 +0200
In-Reply-To: <20100414000823.29004.98991.stgit@bumblebee1.mtv.corp.google.com> (Salman's message of "Tue, 13 Apr 2010 17:08:33 -0700")
Message-ID: <87fx2y9xdn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salman <sqazi@google.com> writes:
> +
> +static int proc_stats(struct ctl_table *table, int write,
> +		      void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	int ret;
> +	unsigned long stats[3];
> +	int cpu = (int)((long)table->extra1);
> +	struct ctl_table fake = {};
> +
> +	if (write)
> +		return -EINVAL;
> +
> +	fake.data = stats;
> +	fake.maxlen = 3*sizeof(unsigned long);
> +
> +	ret = smp_call_function_single(cpu, getstats, &stats, 1);
> +	if (ret)
> +		return ret;

Haven't read the whole thing, but do any of these stats really
need to execute on the target CPU? They seem to be just readable
fields.

Or does it simply not matter because this proc call is too infrequent?

Anyways global broadcasts are discouraged, there is typically
always someone who feels their RT latency be messed up by them.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
