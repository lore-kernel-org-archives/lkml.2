Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab0JYQDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:03:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:37380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab0JYQDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:03:47 -0400
Message-ID: <4CC5AA5F.9060909@kernel.org>
Date: Mon, 25 Oct 2010 18:03:43 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about synchronize_sched_expedited()
References: <20101025154358.GA6919@linux.vnet.ibm.com>
In-Reply-To: <20101025154358.GA6919@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 25 Oct 2010 16:03:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On 10/25/2010 05:43 PM, Paul E. McKenney wrote:
> Hello, Tejun,
> 
> I was taking another look at synchronize_sched_expedited(), and was
> concerned about the scenario listed out in the following commit.
> Is this scenario a real problem, or am I missing the synchronization
> that makes it safe?
> 
> (If my concerns are valid, I should also be able to change this
> to non-atomically increment synchronize_sched_expedited_count, but
> one step at a time...)

I think your concern is valid and this can happen w/o preemption given
enough cpus and perfect timing.  Was the original code free from this
problem?

IMHO the counter based mechanism is a bit too difficult to ponder and
verify.  Can we do more conventional double queueing (ie. flipping
pending and executing queues so that multiple sync calls can get
coalesced while another one is in progress)?  That's what the code is
trying to achieve anyway, right?

Thanks.

-- 
tejun
