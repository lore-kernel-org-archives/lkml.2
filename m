Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0EHMr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 08:47:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:59536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab0EHMr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 08:47:56 -0400
Message-ID: <4BE55D49.5040705@kernel.org>
Date: Sat, 08 May 2010 14:47:05 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: peterz@infradead.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [GIT PULL sched/core] cpu_stop: implement and use cpu_stop, take#3
References: <1273164772-19149-1-git-send-email-tj@kernel.org> <20100508111529.GA19796@elte.hu>
In-Reply-To: <20100508111529.GA19796@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 12:47:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On 05/08/2010 01:15 PM, Ingo Molnar wrote:
> FYI, it doesnt build on x86 allnoconfig:
> 
> kernel/sched_fair.c: In function 'load_balance':
> kernel/sched_fair.c:2917: error: implicit declaration of function 'stop_one_cpu_nowait'
> kernel/sched.c: In function 'sched_exec':
> kernel/sched.c:3084: error: implicit declaration of function 'stop_one_cpu'
> kernel/sched.c: In function 'synchronize_sched_expedited':

The commit is fc390cde362309f6892bb719194f242c466a978b, right?  Yeah,
it's missing the dummy definitions for UP.  The strange thing is that
the commit builds fine w/ allnoconfig on x86 and x86_64.  Ah... maybe
other changes in sched/core makes use of stop_cpu*() from UP code
path.  Anyways, will fix it right away.

Thanks.

-- 
tejun
