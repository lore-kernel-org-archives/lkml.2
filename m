Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab1FPO0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:26:12 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:40398 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab1FPO0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:26:10 -0400
Message-ID: <4DFA126D.9060102@fr.ibm.com>
Date: Thu, 16 Jun 2011 16:25:49 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Greg Kurz <gkurz@fr.ibm.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, containers@lists.osdl.org,
        akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was	Vpid:)
References: <20110615145527.4016.70157.stgit@bahia.local> <20110615190302.GA16440@redhat.com> <1308223158.8230.66.camel@bahia.local> <4DF9F657.7030605@fr.ibm.com> <20110616130613.GC19312@redhat.com>
In-Reply-To: <20110616130613.GC19312@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 03:06 PM, Oleg Nesterov wrote:
> On 06/16, Cedric Le Goater wrote:
>>
>> We have a case where a task in a parent pid namespace needs to kill
>> another task in a sub pid namespace only knowing its internal pid.
>> the latter has been communicated to the parent task through a file or
>> a unix socket.
> 
> OK, thanks, this partly answers my question... But if they communicate
> anyway, it is not clear why the signal is needed.

Well, user space always finds ways to challenge the kernel.

Our case is related to HPC. The batch manager runs jobs inside lxc 
containers (using namespaces) and signals are sent to the application 
for different reasons. First, to cleanly exit but also for other more 
specific actions related to the cluster interconnects. 

>> This 'ActivePid' information in /proc is not sufficient to identity
>> the task, you also need the list of the tasks which are living in
>> the pid namespace.
> 
> Yes, I see.
> 
>> a new kill syscall could be the solution:
>>
>>     int pidns_kill(pid_t init_pid, pid_t some_pid);
>>
>> where 'init_pid' identifies the namespace and 'some_pid' identifies
>> a task in this namespace. this is very specific but why not.
> 
> Yes, I also thought about this. Should be trivial.
> 
> Or int sys_tell_me_its_pid(pid_t init_pid, pid_t some_pid).

why not. it's even better because more general.

> Just in case.... This is hack, yes, but in fact you do not need the
> kernel changes to send a signal inside the namespace. You could
> ptrace sub_init, and execute the necessary code "inside" the namespace.

hmm, I look at that.

Thanks,

C.
