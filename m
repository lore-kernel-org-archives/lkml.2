Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab2EAN7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:59:15 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36428 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2EAN7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:59:14 -0400
Message-ID: <4F9FEC10.1080102@linux.vnet.ibm.com>
Date: Tue, 01 May 2012 19:28:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: get/put_online_cpus documentation wrong?
References: <20120501001238.GA15497@bloggs.ozlabs.ibm.com> <CAOtvUMfgAGBXx-nvFbMHywYGLmKfmbpcQajddoGYA+B22vLOiw@mail.gmail.com>
In-Reply-To: <CAOtvUMfgAGBXx-nvFbMHywYGLmKfmbpcQajddoGYA+B22vLOiw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050103-5140-0000-0000-0000012956D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 04:56 PM, Gilad Ben-Yossef wrote:

> On Tue, May 1, 2012 at 3:12 AM, Paul Mackerras <paulus@samba.org> wrote:
>>
>> In Documentation/cpu-hotplug.txt it says:
>>
>> "       #include <linux/cpu.h>
>>        get_online_cpus() and put_online_cpus():
>>
>> The above calls are used to inhibit cpu hotplug operations. While the
>> cpu_hotplug.refcount is non zero, the cpu_online_mask will not change.
>> If you merely need to avoid cpus going away, you could also use
>> preempt_disable() and preempt_enable() for those sections.
>> Just remember the critical section cannot call any
>> function that can sleep or schedule this process away."
> 
> 
> I *think* the critical section remark here is referring to using
> preempt_disable/enable(),
> rather  then the use of get/put_online_cpus().
>


Yes, what Gilad said is right.

Using preempt_disable()/preempt_enable() around a piece of code is a
light-weight way of preventing CPUs from going away (CPUs going offline)
while executing that code. (However, they don't prevent new CPUs from
coming online). So, if you are using preempt_disable|enable() to
prevent some CPU from going offline, then the usual rules for using
preempt_disable|enable() apply - that code should not sleep.

But if you want to avoid CPU hotplug entirely (both CPU offlining and
onlining), then you should use get/put_online_cpus(). You can use this
around any piece of code, including those which can sleep.

 

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

