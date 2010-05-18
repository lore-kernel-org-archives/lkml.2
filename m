Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab0ERSjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:39:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:15010 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab0ERSjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iyCOmTvrPPgz9JCHuPqr5TRfaWonnYZjPXnl/RNPsGr75eHoJv8IB/SdnWE4mC+MN1
         PUJ3XudWyqSh0ADT7Rs8BGDii3AaC8Af/cSeA2b9az8QrWS3RrTrSJ6tEmT+spL/ccUa
         bSqeSQXvIkcNwMkt3v1749BOCNPaB1CKdLeRQ=
Date: Tue, 18 May 2010 22:38:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 02/11] perf: core, add pmu register and lookup
	functions
Message-ID: <20100518183858.GE5081@lenovo>
References: <1274233502.3036.80.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274233502.3036.80.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 01:45:02AM +0000, Lin Ming wrote:
...
> +int perf_event_register_pmu(struct pmu *pmu)
> +{
> +	struct pmu *tmp;
> +	int ret = 1;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(tmp, &pmus, entry) {
> +		if (tmp->id == pmu->id) {
> +			ret = 0;
> +			goto err;

Hi Ming, is it supposed to get out in locked state?
I mean imbalanced rcu_read_lock somehow suspicicous ;)

> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	spin_lock(&pmus_lock);
> +	list_add_tail_rcu(&pmu->entry, &pmus);
> +	spin_unlock(&pmus_lock);
> +
> +err:
> +	return ret;
> +}
> +
...

	-- Cyrill
