Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1FVJjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:39:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41342 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab1FVJjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:39:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E01B82F.6060101@jp.fujitsu.com>
Date: Wed, 22 Jun 2011 18:38:55 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 07/16] sched: expire invalid runtime
References: <20110621071649.862846205@google.com> <20110621071700.395400025@google.com>
In-Reply-To: <20110621071700.395400025@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/21 16:16), Paul Turner wrote:
> Since quota is managed using a global state but consumed on a per-cpu basis
> we need to ensure that our per-cpu state is appropriately synchronized.  
> Most importantly, runtime that is state (from a previous period) should not be
> locally consumable.
> 
> We take advantage of existing sched_clock synchronization about the jiffy to
> efficiently detect whether we have (globally) crossed a quota boundary above.
> 
> One catch is that the direction of spread on sched_clock is undefined, 
> specifically, we don't know whether our local clock is behind or ahead
> of the one responsible for the current expiration time.
> 
> Fortunately we can differentiate these by considering whether the
> global deadline has advanced.  If it has not, then we assume our clock to be 
> "fast" and advance our local expiration; otherwise, we know the deadline has
> truly passed and we expire our local runtime.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> ---

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

