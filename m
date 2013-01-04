Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3ADLlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:41:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57649 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab3ADLl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:41:29 -0500
Message-ID: <1357299679.4578.31.camel@marge.simpson.net>
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
From: Mike Galbraith <bitbucket@online.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Alex Shi <alex.shi@intel.com>,
        srikar@linux.vnet.ibm.com
Date: Fri, 04 Jan 2013 12:41:19 +0100
In-Reply-To: <50E55F99.6090104@linux.vnet.ibm.com>
References: <50E3B61A.3040808@linux.vnet.ibm.com>
	 <1357114354.5586.39.camel@marge.simpson.net>
	 <50E55F99.6090104@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:1TXdh0JBuvA0MqtFQzl3+cRsU0KhfwO5puHdcmVRkio
 DtPuhafYMr0q8dnruwUTmETocZ88x8qAzu7UszXVaEpPfhEXct
 VmvwgZqnOqZfU60Wn/yf2cbP+kS2X3leTsdI7Cz4+M+0bj7eM/
 Ea8/+1/BkvSqwgGSB1defjBy/4TYYBnNE3XvGfzRIVtYglzcPb
 XWCktLg7RbK18iUmKocTD8IdpfrHEwX4794eUszqA085ae/E2H
 ecdLeIUKGZXF1aNNAY2pjtX/ntFKG3tw5E+hf3Qeory4V9hGsF
 6sE5x+udAFc8dMC+2CC9M7YdwZ1pdSmFji/2VjEooOLTKbM9vc
 B0N1Dqup7m/RW0Fka08dXel3wtTToleVesQvwzURiDnnpsVMkc
 JRQEABgLM/pWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 16:08 +0530, Preeti U Murthy wrote: 
> Hi Mike,
> 
> Thank you very much for your feedback.Considering your suggestions,I have posted out a 
> proposed solution to prevent select_idle_sibling() from becoming a disadvantage to normal
> load balancing,rather aiding it.
> 
> **This patch is *without* the enablement of the per entity load tracking metric.**
> 
> This is with an intention to correct the existing select_idle_sibling() mess before
> going ahead.

Well, on the bright side, this is much kinder to light load tbench on
4x10 core (+ht) box than current bounce happy select_idle_sibling().  At
the heavy load end I'm losing heaping truckloads of throughput though,
likely some migration rate limiting would fix that up.

select_idle_sibling() doesn't have much of a pretty face these days, but
its evil hag face shows more prominently than ever, so making it dead is
a great goal ;-)

-Mike

