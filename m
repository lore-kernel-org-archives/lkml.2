Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0EaKGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:06:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:47243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab0EaKG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:06:29 -0400
Message-ID: <4C038A08.8090209@kernel.org>
Date: Mon, 31 May 2010 12:06:00 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/4] sched: implement __set_cpus_allowed()
References: <1273747705-7829-1-git-send-email-tj@kernel.org>	 <1273747705-7829-3-git-send-email-tj@kernel.org>	 <1275292866.27810.21441.camel@twins>  <4C03879A.8030505@kernel.org>	 <1275300084.27810.21850.camel@twins> <1275300165.27810.21858.camel@twins>
In-Reply-To: <1275300165.27810.21858.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 10:06:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 12:02 PM, Peter Zijlstra wrote:
> On Mon, 2010-05-31 at 12:01 +0200, Peter Zijlstra wrote:
>>>  but we can update cpu_active mask before other
>>> CPU_UP_PREPARE notifiers are executed so that it's symmetrical to cpu
>>> down path and then this problem goes away the exact same way, right?
>>
>> Ah, no, we cannot mark it active before its actually up, because at that
>> time we'll actually try and run stuff on it, which clearly won't work
>> when its not there to run stuff. 
> 
> So we should clear it _before_ we go down, and set it _after_ we're up.
> 

Yeah, sure, I misspoke.  I meant CPU_ONLINE not CPU_UP_PREPARE.  So,
we can mark a cpu active before other CPU_ONLINE callbacks are run.

Thanks.

-- 
tejun
