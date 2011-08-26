Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1HZMo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:44:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:25940 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab1HZMoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:44:55 -0400
Message-ID: <4E579541.6060607@openvz.org>
Date: Fri, 26 Aug 2011 16:44:49 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110702 Iceape/2.0.14
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] oom: skip frozen tasks
References: <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com> <20110824101927.GB3505@tiehlicka.suse.cz> <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com> <20110825091920.GA22564@tiehlicka.suse.cz> <20110825151818.GA4003@redhat.com> <20110825164758.GB22564@tiehlicka.suse.cz> <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com> <20110826070946.GA7280@tiehlicka.suse.cz> <20110826085610.GA9083@tiehlicka.suse.cz> <4E576F65.5060009@openvz.org> <20110826104827.GC9083@tiehlicka.suse.cz>
In-Reply-To: <20110826104827.GC9083@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko wrote:
> On Fri 26-08-11 14:03:17, Konstantin Khlebnikov wrote:
>> Michal Hocko wrote:
>>
>>> @@ -450,6 +459,10 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
>>>   			pr_err("Kill process %d (%s) sharing same memory\n",
>>>   				task_pid_nr(q), q->comm);
>>>   			task_unlock(q);
>>> +
>>> +			if (frozen(q))
>>> +				thaw_process(q);
>>> +
>>
>> We must thaw task strictly after sending SIGKILL.
>
> Sounds reasonable.
>
>> But anyway I think this is a bad idea.
>
> Why?

Refrigerator may be used for digging in task's internal structures,
so such digger may be very surprised if somebody suddenly thaws this task.

>
>>
>>>   			force_sig(SIGKILL, q);
>>>   		}
>>>
>

