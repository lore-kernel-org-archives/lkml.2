Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1FVJie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:38:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41321 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1FVJid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:38:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E01B7FE.8030300@jp.fujitsu.com>
Date: Wed, 22 Jun 2011 18:38:06 +0900
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
Subject: Re: [patch 04/16] sched: validate CFS quota hierarchies
References: <20110621071649.862846205@google.com> <20110621071700.092877579@google.com>
In-Reply-To: <20110621071700.092877579@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/21 16:16), Paul Turner wrote:
> Add constraints validation for CFS bandwidth hierarchies.
> 
> Validate that:
>    max(child bandwidth) <= parent_bandwidth
> 
> In a quota limited hierarchy, an unconstrained entity
> (e.g. bandwidth==RUNTIME_INF) inherits the bandwidth of its parent.
> 
> This constraint is chosen over sum(child_bandwidth) as notion of over-commit is
> valuable within SCHED_OTHER.  Some basic code from the RT case is re-factored
> for reuse.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> ---

The sysctl_sched_cfs_bandwidth_consistent is gone for good.
Now it is no longer complicated.

(Though there is a trivial typo pointed by Bharata, soon it will be fixed.)
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

