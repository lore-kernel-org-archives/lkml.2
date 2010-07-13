Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab0GMG7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:59:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42549 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab0GMG7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:59:21 -0400
Message-ID: <4C3C0EBC.40305@us.ibm.com>
Date: Mon, 12 Jul 2010 23:59:08 -0700
From: Sridhar Samudrala <sri@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH repost] sched: export sched_set/getaffinity to modules
References: <20100701130816.GB32223@redhat.com> <1277991024.1917.108.camel@laptop> <20100701133956.GD32223@redhat.com> <4C2CA5C5.4040402@kernel.org> <20100701144624.GA11171@redhat.com> <4C2CABF2.2020801@kernel.org> <1277996135.1917.198.camel@laptop> <4C2E2987.9040702@us.ibm.com> <1278094270.1917.288.camel@laptop> <20100702210637.GA12433@redhat.com> <20100704090005.GA8078@redhat.com>
In-Reply-To: <20100704090005.GA8078@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/4/2010 2:00 AM, Michael S. Tsirkin wrote:
> On Fri, Jul 02, 2010 at 11:06:37PM +0200, Oleg Nesterov wrote:
>    
>> On 07/02, Peter Zijlstra wrote:
>>      
>>> On Fri, 2010-07-02 at 11:01 -0700, Sridhar Samudrala wrote:
>>>        
>>>>   Does  it (Tejun's kthread_clone() patch) also  inherit the
>>>> cgroup of the caller?
>>>>          
>>> Of course, its a simple do_fork() which inherits everything just as you
>>> would expect from a similar sys_clone()/sys_fork() call.
>>>        
>> Yes. And I'm afraid it can inherit more than we want. IIUC, this is called
>> from ioctl(), right?
>>
>> Then the new thread becomes the natural child of the caller, and it shares
>> ->mm with the parent. And files, dup_fd() without CLONE_FS.
>>
>> Signals. Say, if you send SIGKILL to this new thread, it can't sleep in
>> TASK_INTERRUPTIBLE or KILLABLE after that. And this SIGKILL can be sent
>> just because the parent gets SIGQUIT or abother coredumpable signal.
>> Or the new thread can recieve SIGSTOP via ^Z.
>>
>> Perhaps this is OK, I do not know. Just to remind that kernel_thread()
>> is merely clone(CLONE_VM).
>>
>> Oleg.
>>      
>
> Right. Doing this might break things like flush.  The signal and exit
> behaviour needs to be examined carefully. I am also unsure whether
> using such threads might be more expensive than inheriting kthreadd.
>
>    
Should we just leave it to the userspace to set the cgroup/cpumask after 
qemu starts the guest and
the vhost threads?

Thanks
Sridhar


