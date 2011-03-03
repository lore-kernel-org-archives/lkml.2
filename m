Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1CCDON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:14:13 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:53088 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756924Ab1CCDOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:14:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=L/1hDAtArsj6K1JNOlRb6IVk3FMh+9nYuMBqYYrWZv/hViPspRlPkANR6B8OMAU55h9zgxl4ehzZs1or9rbUrpOv3hThe7Y1dv0lobqI3iSUc7yJw9h+fuo8kVwR79Cy;
Message-ID: <4D6F077B.3060400@tao.ma>
Date: Thu, 03 Mar 2011 11:14:03 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Liu Yuan <namei.unix@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jaxboe@fusionio.com, akpm@linux-foundation.org,
        fengguang.wu@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 4/5] mm: Add hit/miss accounting for Page Cache
References: <no> <1299055090-23976-4-git-send-email-namei.unix@gmail.com> <20110302084542.GA20795@elte.hu>
In-Reply-To: <20110302084542.GA20795@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 04:45 PM, Ingo Molnar wrote:
> * Liu Yuan<namei.unix@gmail.com>  wrote:
>
>    
>> +		if (likely(!retry_find)&&  page&&  PageUptodate(page))
>> +			page_cache_acct_hit(inode->i_sb, READ);
>> +		else
>> +			page_cache_acct_missed(inode->i_sb, READ);
>>      
> Sigh.
>
> This would make such a nice tracepoint or sw perf event. It could be collected in a
> 'count' form, equivalent to the stats you are aiming for here, or it could even be
> traced, if someone is interested in such details.
>
> It could be mixed with other events, enriching multiple apps at once.
>
> But, instead of trying to improve those aspects of our existing instrumentation
> frameworks, mm/* is gradually growing its own special instrumentation hacks, missing
> the big picture and fragmenting the instrumentation space some more.
>    
Thanks for the quick response. Actually our team(including Liu) here are 
planing to add some
debug info to the mm parts for analyzing the application behavior and 
hope to find some way
to improve our application's performance.
We have searched the trace points in mm, but it seems to us that the 
trace points isn't quite welcomed
there. Only vmscan and writeback have some limited trace points added. 
That's the reason we first
tried to add some debug info like this patch. You does shed some light 
on our direction. Thanks.

btw, what part do you think is needed to add some trace point?  We 
volunteer to add more if you like.

Regards,
Tao
