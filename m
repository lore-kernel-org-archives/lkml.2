Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2HOQod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:44:33 -0400
Received: from relay.parallels.com ([195.214.232.42]:46617 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab2HOQoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:44:32 -0400
Message-ID: <502BD1C5.6080002@parallels.com>
Date: Wed, 15 Aug 2012 20:43:49 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "bfields@redhat.com" <bfields@redhat.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "devel@openvz.org" <devel@openvz.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH 5/5] syscall: sys_fbind() introduced
References: <20120815161141.7598.16682.stgit@localhost.localdomain> <20120815162225.7598.85131.stgit@localhost.localdomain> <502BCEAD.7050905@zytor.com>
In-Reply-To: <502BCEAD.7050905@zytor.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15.08.2012 20:30, H. Peter Anvin пишет:
> On 08/15/2012 09:22 AM, Stanislav Kinsbursky wrote:
>> This syscall allows to bind socket to specified file descriptor.
>> Descriptor can be gained by simple open with O_PATH flag.
>> Socket node can be created by sys_mknod().
>>
>> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
>> ---
>>    arch/x86/syscalls/syscall_32.tbl |    1 +
>>    arch/x86/syscalls/syscall_64.tbl |    1 +
>>    include/linux/syscalls.h         |    1 +
>>    kernel/sys_ni.c                  |    3 +++
>>    net/socket.c                     |   25 +++++++++++++++++++++++++
>>    5 files changed, 31 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
>> index 7a35a6e..9594b82 100644
>> --- a/arch/x86/syscalls/syscall_32.tbl
>> +++ b/arch/x86/syscalls/syscall_32.tbl
>> @@ -356,3 +356,4 @@
>>    347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
>>    348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
>>    349	i386	kcmp			sys_kcmp
>> +350	i386	fbind			sys_fbind
>
> i386 uses socketcalls... perhaps it shouldn't (socketcalls are pretty
> much an abomination), but for socketcall-based architectures this really
> should be a socketcall.
>

Thanks, Peter. I'll rework this.

> Don't you also need fconnect()?  Or is that simply handled by allowing
> open() without O_PATH?
>

Yes, I need it.
If this approach will be accepted, then I'll send one more patch set for fconnect.

> 	-hpa
>


-- 
Best regards,
Stanislav Kinsbursky
