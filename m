Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab2C1VK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:10:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43113 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab2C1VKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:10:54 -0400
MIME-Version: 1.0
In-Reply-To: <4F7146EA.1030305@zytor.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
 <1332787168-20457-3-git-send-email-vnagarnaik@google.com> <4F7146EA.1030305@zytor.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 28 Mar 2012 14:10:23 -0700
Message-ID: <CAL26m8JfVekNQC75dSmH+JDFwATdGYjyV-GBx+KrbCSeW-6V2Q@mail.gmail.com>
Subject: Re: [PATCH 2/6] trace: add support for 32 bit compat syscalls on x86_64
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Michael Davidson <md@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 9:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/26/2012 11:39 AM, Vaibhav Nagarnaik wrote:
>> +/*
>> + * syscall metadata for 32 bit compatible system calls
>> + *
>> + * The metadata entries are in the same order as the system call table
>> + * but this is just to make it easier to check them for completeness
>> + * and correctness.
>> + */
>> +
>> +COMPAT_SYSCALL_METADATA0(restart_syscall)
>> +COMPAT_SYSCALL_METADATA1(exit, int, error_code)
>   [...]
>> +COMPAT_SYSCALL_METADATA5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg, unsigned int, vlen, unsigned int, flags, struct timespec __user *, timeout)
>
>> +/*
>> + * This is truly horrible.
>
> Yes, it is.  How on Earth do you expect the above to ever be maintained?

You are right. I found that I can just reuse the SYSCALL_DEFINEx macro
to define the compat syscall metadata. I am sending the new patch, can
you take a look again?


Thanks


Vaibhav Nagarnaik
