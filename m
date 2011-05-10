Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1EJHXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:23:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49895 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1EJHXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:23:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E7C2.5080402@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:22:42 +0900
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
Subject: Re: [patch 07/15] sched: expire invalid runtime
References: <20110503092846.022272244@google.com> <20110503092905.075386331@google.com>
In-Reply-To: <20110503092905.075386331@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/03 18:28), Paul Turner wrote:
> With the global quota pool, one challenge is determining when the runtime we
> have received from it is still valid.  Fortunately we can take advantage of
> sched_clock synchronization around the jiffy to do this cheaply.
> 
> The one catch is that we don't know whether our local clock is behind or ahead
> of the cpu setting the expiration time (relative to its own clock).
> 
> Fortunately we can detect which of these is the case by determining whether the
> global deadline has advanced.  If it has not, then we assume we are behind, and
> advance our local expiration; otherwise, we know the deadline has truly passed
> and we expire our local runtime.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> ---

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

