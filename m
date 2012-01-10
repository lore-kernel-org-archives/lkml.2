Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab2AJOyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 09:54:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:51186 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab2AJOyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 09:54:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94309049"
Message-ID: <4F0C5138.5010109@linux.intel.com>
Date: Tue, 10 Jan 2012 06:54:48 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>  <1326103578.2442.50.camel@twins>  <20120110001445.GA20542@linux-youquan.bj.intel.com>  <1326107156.2442.59.camel@twins>  <20120110055856.GA23741@linux-youquan.bj.intel.com>  <1326153163.2366.7.camel@sbsiddha-mobl2> <20120110091805.GA28024@elte.hu>  <4F0C4BF0.9090809@linux.intel.com> <1326206478.2442.111.camel@twins>
In-Reply-To: <1326206478.2442.111.camel@twins>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2012 6:41 AM, Peter Zijlstra wrote:
> On Tue, 2012-01-10 at 06:32 -0800, Arjan van de Ven wrote:
>>
>> a very good default would be to keep all tasks on one package until half
>> the cores in the package are busy, and then start spreading out. 
> 
> Does that still make sense when there's strong NUMA preference? By
> forcing stuff on a single package you increase the number of remote
> memory fetches (which generally generate more stalls), also the memory
> controllers need to stay awake anyway.

the memory controllers need to stake regardless of what you do;
it's more a memory bandwidth kind of thing.

if you have an enormous numa factor (>= 10 or so), then you really need
a completely different policy I suspect.
Thankfully those are rare.
