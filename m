Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab1DMBYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:24:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:19881 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab1DMBYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:24:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,200,1301900400"; 
   d="scan'208";a="678295958"
Subject: Re: [PATCH 1/4]percpu_counter: make API return consistent value
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>
In-Reply-To: <20110412184927.GB16342@mtj.dyndns.org>
References: <1302595437.3981.127.camel@sli10-conroe>
	 <20110412184927.GB16342@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 09:24:15 +0800
Message-ID: <1302657855.3981.153.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 02:49 +0800, Tejun Heo wrote:
> Hello,
> 
> First of all, please somehow link patches of the same series.  Either
> write a head message and make all the patches replies to it
> (preferred) or chain reply the patches (only when the number of
> patches is small).
> 
> On Tue, Apr 12, 2011 at 04:03:57PM +0800, Shaohua Li wrote:
> > the percpu_counter_*_positive() API SMP and !SMP aren't consistent. From
> > the API name, we should return a non-negative value for them.
> > Also if count < 0, returns 0 instead of 1 for *read_positive().
> 
> Ummm, on UP, the counters cannot be positive.
s/positive/negative?

>   The _positive interface
> is there to make it easier to cope with deviations introduced by
> unsynchronized modifications by different CPUs.  On UP, such
> deviations don't happen at all so _positive interface is the same as
> the counterpart without the postfix.
I'm confused. the counter could be negative, we have *_dec, *_sub.

Thanks,
Shaohua

