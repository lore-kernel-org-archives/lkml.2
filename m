Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2AXSBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:01:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49424 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2AXSBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:01:05 -0500
Message-ID: <4F1EF1E8.4090909@jp.fujitsu.com>
Date: Tue, 24 Jan 2012 13:01:12 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: peterz@infradead.org
CC: kosaki.motohiro@gmail.com, oleg@redhat.com, y-goto@jp.fujitsu.com,
        mingo@elte.hu, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
References: <1324633794.24803.48.camel@twins>  <20111223154137.GA27901@redhat.com>  <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com>  <20111226171151.GA4472@redhat.com>  <4EFB8523.6080708@gmail.com> <1327400618.2614.13.camel@laptop>
In-Reply-To: <1327400618.2614.13.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/2012 5:23 AM, Peter Zijlstra wrote:
> On Wed, 2011-12-28 at 16:07 -0500, KOSAKI Motohiro wrote:
>> I looked at scheduler code today briefly. now I'm afraid following code 
>> have similar race.
>>
>>
>>          if (task_contributes_to_load(p))
>>                  rq->nr_uninterruptible--;
>>
>>
>>
>> Can't following schenario be happen?
>>
>>
>> CPU0                    CPU1
>> --------------------------------------------------------
>> deactivate_task()
>>                         task->state = TASK_UNINTERRUPTIBLE;
>> activate_task()
>>    rq->nr_uninterruptible--;
>>
>>                         schedule()
>>                           deactivate_task()
>>                             rq->nr_uninterruptible++;
>>
>> Totally, nr_uninterruptible wasn't incremented.
>>
>>
>> I'm still not sure. I need to read more sched code. 
> 
> You shouldn't ever set another tasks ->state. 

I'm sorry. I haven't catch your point. I think following step is
valid kernel code. Do you disagree?

>>                         task->state = TASK_UNINTERRUPTIBLE;
>>                         schedule()

