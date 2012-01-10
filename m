Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2AJOcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 09:32:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:9292 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab2AJOcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 09:32:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94301083"
Message-ID: <4F0C4BF0.9090809@linux.intel.com>
Date: Tue, 10 Jan 2012 06:32:16 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com> <1326103578.2442.50.camel@twins> <20120110001445.GA20542@linux-youquan.bj.intel.com> <1326107156.2442.59.camel@twins> <20120110055856.GA23741@linux-youquan.bj.intel.com> <1326153163.2366.7.camel@sbsiddha-mobl2> <20120110091805.GA28024@elte.hu>
In-Reply-To: <20120110091805.GA28024@elte.hu>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2012 1:18 AM, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
>> On Tue, 2012-01-10 at 00:58 -0500, Youquan Song wrote:
>>> Thanks Peter! Here is the patch. 
>>
>> Youquan, As far as I know both the
>> sched_smt_power_savings/sched_mc_power_savings are broken for atleast an
>> year.
> 
> We want a single knob, sched_power_savings - with the mc_ and 
> smt_ ones still kept and aliased to sched_power_savings, for 
> compatibility reasons.
> 
> As Peter said, the other reasonable option is to have no knob at 
> all and restart this code from scratch.
> 
> The other thing we should do is to add sane defaults: to turn on 
> sched_power_savings *AUTOMATICALLY* when a system is obviously 
> battery driven and turn it off when the system is obviously AC 
> driven. User-space can still implement policy and override the 
> kernel's default, but there's absolutely no excuse to not offer 
> this default ourselves.

a very good default would be to keep all tasks on one package until half
the cores in the package are busy, and then start spreading out.

I suspect that'll be the 90% case coverage.
