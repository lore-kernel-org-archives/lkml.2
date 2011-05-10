Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1EJH1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:27:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49099 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1EJH1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:27:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E8BA.3010106@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:26:50 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
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
Subject: Re: [patch 11/15] sched: prevent interactions between throttled entities
 and load-balance
References: <20110503092846.022272244@google.com> <20110503092905.427302001@google.com>
In-Reply-To: <20110503092905.427302001@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/03 18:28), Paul Turner wrote:
>>From the perspective of load-balance and shares distribution, throttled
> entities should be invisible.
> 
> However, both of these operations work on 'active' lists and are not
> inherently aware of what group hierarchies may be present.  In some cases this
> may be side-stepped (e.g. we could sideload via tg_load_down in load balance) 
> while in others (e.g. update_shares()) it is more difficult to compute without
> incurring some O(n^2) costs.
> 
> Instead, track hierarchal throttled state at time of transition.  This allows

                 hierarchical

> us to easily identify whether an entity belongs to a throttled hierarchy and
> avoid incorrect interactions with it.
> 
> Also, when an entity leaves a throttled hierarchy we need to advance its
> time averaging for shares averaging so that the elapsed throttled time is not
> considered as part of the cfs_rq's operation.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> ---

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Thanks,
H.Seto

