Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab2BHTnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:43:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab2BHTnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:43:04 -0500
Message-ID: <4F32D042.7080907@redhat.com>
Date: Wed, 08 Feb 2012 19:42:58 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
References: <20120203162519.GB805@google.com> <4F2C0F13.70709@parallels.com> <20120203165132.GA5636@redhat.com> <4F31848A.9070406@redhat.com> <20120207205639.GJ27437@moon> <4F31945B.5000304@redhat.com> <20120207215121.GB29773@moon> <4F326AF7.3060203@redhat.com> <20120208173103.GA20853@redhat.com> <4F32B924.8080407@redhat.com> <20120208190250.GA23163@redhat.com>
In-Reply-To: <20120208190250.GA23163@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 07:02 PM, Oleg Nesterov wrote:
> On 02/08, Pedro Alves wrote:
>>
>> On 02/08/2012 05:31 PM, Oleg Nesterov wrote:
>>> On 02/08, Pedro Alves wrote:
>>>>
>>>> I just tried it.  This is &pthread->tid in glibc/libpthread, so with debug
>>>> info it's easy to figure out where to set the watchpoint manually with gdb
>>>> without asking the kernel.  Doesn't work.  ptrace doesn't show any trap
>>>> for the kernel writes.
>>>
>>> The tracee simply can't report this trap. it is already dead ;) and
>>> hw breakpoint (used by ptrace) is "pinned" to the thread.
>>
>> Right, as I said.  :-)  I saw that a watchpoint trap isn't reported either
>> for the CLONE_CHILD_SETTID case (that is, within clone, when the kernel
>> writes the tid to the memory address passed in to the clone syscall).
> 
> Yes. But in this case the new thread has no bps even if it is auto-
> attached.

Ah, right.  It used to be the kernel copied the debug registers from
parent->child, but they're always cleared in the child nowadays
(since 72f674d203cd230426437cdcf7dd6f681dad8b0d).

>> I wouldn't have been surprised to see the trap in userspace in either
>> the parent
> 
> It would be just wrong. Please note that it is child, not parent, who
> does the write.

Okay, I didn't know which it was that touched the memory,
hence the "either".  Thanks.  Paired with the
we-now-clear-debug-regs-on-clone thing, it makes sense.

-- 
Pedro Alves
