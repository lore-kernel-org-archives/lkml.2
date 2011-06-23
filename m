Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1FWP1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:27:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:57405 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520Ab1FWP1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:27:15 -0400
Subject: Re: [patch 15/16] sched: return unused runtime on voluntary sleep
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110621071701.165027089@google.com>
References: <20110621071649.862846205@google.com>
	 <20110621071701.165027089@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 17:26:18 +0200
Message-ID: <1308842778.1022.136.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 00:17 -0700, Paul Turner wrote:
> plain text document attachment (sched-bwc-simple_return_quota.patch)
> When a local cfs_rq blocks we return the majority of its remaining quota to the
> global bandwidth pool for use by other runqueues.

OK, I saw return_cfs_rq_runtime() do that.

> We do this only when the quota is current and there is more than 
> min_cfs_rq_quota [1ms by default] of runtime remaining on the rq.

sure..

> In the case where there are throttled runqueues and we have sufficient
> bandwidth to meter out a slice, a second timer is kicked off to handle this
> delivery, unthrottling where appropriate.

I'm having trouble there, what's the purpose of the timer, you could
redistribute immediately. None of this is well explained.
