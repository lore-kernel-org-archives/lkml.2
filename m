Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0EDGl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:41:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:60138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0EDGlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:41:25 -0400
Message-ID: <4BDFC16A.8070500@kernel.org>
Date: Tue, 04 May 2010 08:40:42 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/4] cpu_stop: implement stop_cpu[s]()
References: <1271952554-22368-1-git-send-email-tj@kernel.org>	 <1271952554-22368-2-git-send-email-tj@kernel.org> <1272893191.5605.121.camel@twins>
In-Reply-To: <1272893191.5605.121.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 06:40:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/03/2010 03:26 PM, Peter Zijlstra wrote:
> If you do:
> 
>  done = { .ret = -ENOENT, };
> 
> And remove that if()
> 
>> +		ret = work->fn(work->arg);
>> +		if (ret)
>> +			done->ret = ret;
>> +
> 
> You can do away with all the ->executed bits.

Oh, I had code piece which wanted to discern between -ENOENT from
non-excution and -ENOENT return from the work function which seems
gone now.  I'll check things again and drop ->executed if everything
looks okay.

Thanks.

-- 
tejun
