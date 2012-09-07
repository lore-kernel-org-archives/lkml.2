Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab2IGCKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:10:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23149 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab2IGCKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:10:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,383,1344182400"; 
   d="scan'208";a="5799454"
Message-ID: <504957EC.60305@cn.fujitsu.com>
Date: Fri, 07 Sep 2012 10:11:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11 V5] workqueue: Add @bind arguement back without
 change any thing
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com> <1346841475-4422-6-git-send-email-laijs@cn.fujitsu.com> <20120905194908.GC13737@google.com> <5047F686.5010207@cn.fujitsu.com> <20120906165145.GE29092@google.com>
In-Reply-To: <20120906165145.GE29092@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/07 10:09:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/07 10:09:42,
	Serialize complete at 2012/09/07 10:09:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 12:51 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Thu, Sep 06, 2012 at 09:04:06AM +0800, Lai Jiangshan wrote:
>>> This doesn't change anything.  You're just moving the test to the
>>> caller with comments there explaining how it won't change even if
>>> gcwq->lock is released.  It seems more confusing to me.  The flag is
>>> still protected by manager_mutex.  How is this an improvement?
>>>
>>
>> Some other bit of gcwq->flags is accessed(modified) without manager_mutex.
>> making gcwq->flags be accessed only form gcwq->lock C.S. will help the reviewer.
>>
>> I don't like adding special things/code when not-absolutely-required.
> 
> I really fail to see this.  The flag has to stay stable while
> manage_mutex is held no matter where you test it. 

Only one bit is stable, the whole flags can be changed outside.

I prefer the whole byte or short or int or long is protected under the same synchronization.
I don't prefer different bit uses different synchronization.

> It doesn't make any
> it any more readable whether you test it inside gcwq->lock with the
> comment saying "this won't change while manager_mutex is held" or just
> test it while manager_mutex is held.  It is a synchronization oddity
> no matter what and as long as it's well documented, I don't really see
> the point in the change.
> 

When I read "gcwq->flags & GCWQ_DISASSOCIATED" in create_worker, I thought:
WTF, gcwq->flags can be change by other, is it correct?. When I saw the comments claim
it is correct, I have to use about 30 mins to check whether it is correct in several
places of code in workqueue.c(include check does flags has internal state in all gcwq->lock).
I'm not good on it, but I think there are some reviewers will be confused like me.

Thanks,
Lai
will be 


