Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab1AaOsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:48:12 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:60492 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1AaOsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:48:11 -0500
Message-ID: <4D46CB9E.1090802@free.fr>
Date: Mon, 31 Jan 2011 15:47:58 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, ebiederm@xmission.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        clg@fr.ibm.com
Subject: Re: [PATCH 4/4] pidns: Use task_active_pid_ns where appropriate
References: <1296469525-30111-1-git-send-email-daniel.lezcano@free.fr>	<1296469525-30111-5-git-send-email-daniel.lezcano@free.fr> <AANLkTikjcou-0b4NejpY66qXeZuzsC-M+oNTyHk=OE-Z@mail.gmail.com>
In-Reply-To: <AANLkTikjcou-0b4NejpY66qXeZuzsC-M+oNTyHk=OE-Z@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 12:26 PM, Alexey Dobriyan wrote:
> On Mon, Jan 31, 2011 at 12:25 PM, Daniel Lezcano<daniel.lezcano@free.fr>  wrote:
>> The expressions tsk->nsproxy->pid_ns and task_active_pid_ns
>> aka ns_of_pid(task_pid(tsk)) should have the same number of
>> cache line misses with the practical difference that
>> ns_of_pid(task_pid(tsk)) is released later in a processes life.
>>
>> Furthermore by using task_active_pid_ns it becomes trivial
>> to write an unshare implementation for the the pid namespace.
>>
>> So I have used task_active_pid_ns everywhere I can.
> Yet current->nsproxy->pid_ns is way clearer.
> Because live current always has pid_ns.
>
> This task_active_pid_ns() is misnamed(?) because it does matter only
> for dead tasks?

Actually this function is later used, for the unshare, to get the pid_ns 
of a specific task, not the current one.

http://kerneltrap.org/mailarchive/linux-kernel/2010/6/20/4585095

Do you suggest task_pid_ns(struct task_struct *tsk) would be a better name ?

>> -               current->nsproxy->pid_ns->last_pid);
>> +               task_active_pid_ns(current)->last_pid);
> I thought of doing exactly opposite patch :-)
>

