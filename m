Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab2LWMRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 07:17:09 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:56100 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2LWMRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 07:17:07 -0500
MIME-Version: 1.0
In-Reply-To: <87k3scf2pn.fsf@sejong.aot.lge.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
	<1355127754-8444-2-git-send-email-alex.shi@intel.com>
	<50C6B530.3030307@linux.vnet.ibm.com>
	<50C6C462.6030808@intel.com>
	<50C6D31F.1030408@linux.vnet.ibm.com>
	<87k3scf2pn.fsf@sejong.aot.lge.com>
Date: Sun, 23 Dec 2012 20:17:06 +0800
Message-ID: <CAGjg+kECsZ1erixN=xiV3Fi9weT21ysU2mVBgS1SXKXAOpo_Ww@mail.gmail.com>
Subject: Re: [PATCH 01/18] sched: select_task_rq_fair clean up
From: Alex Shi <lkml.alex@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, Alex Shi <alex.shi@intel.com>,
        rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 12:28 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi,
>
> On Tue, 11 Dec 2012 12:00:55 +0530, Preeti U. Murthy wrote:
>> On 12/11/2012 10:58 AM, Alex Shi wrote:
>>> On 12/11/2012 12:23 PM, Preeti U Murthy wrote:
>>>> Hi Alex,
>>>>
>>>> On 12/10/2012 01:52 PM, Alex Shi wrote:
>>>>> It is impossible to miss a task allowed cpu in a eligible group.
>>>>
>>>> The one thing I am concerned with here is if there is a possibility of
>>>> the task changing its tsk_cpus_allowed() while this code is running.
>>>>
>>>> i.e find_idlest_group() finds an idle group,then the tsk_cpus_allowed()
>>>> for the task changes,perhaps by the user himself,which might not include
>>>> the cpus in the idle group.After this find_idlest_cpu() is called.I mean
>>>> a race condition in short.Then we might not have an eligible cpu in that
>>>> group right?
>>>
>>> your worry make sense, but the code handle the situation, in
>>> select_task_rq(), it will check the cpu allowed again. if the answer is
>>> no, it will fallback to old cpu.
>>>>
>>>>> And since find_idlest_group only return a different group which
>>>>> excludes old cpu, it's also imporissible to find a new cpu same as old
>>>>> cpu.
>>
>> I doubt this will work correctly.Consider the following situation:sched
>> domain begins with sd that encloses both socket1 and socket2
>>
>> cpu0 cpu1  | cpu2 cpu3
>> -----------|-------------
>>  socket1   |  socket2
>>
>> old cpu = cpu1
>>
>> Iteration1:
>> 1.find_idlest_group() returns socket2 to be idlest.
>> 2.task changes tsk_allowed_cpus to 0,1
>> 3.find_idlest_cpu() returns cpu2
>
> AFAIK The tsk->cpus_allowed cannot be changed during the operation since
> it's protected by tsk->pi_lock.  I can see the following comment:

You are right. I misunderstand some comments in wake_up_new_task.


-- 
Thanks
    Alex
