Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2C0Euf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 00:50:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34983 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab2C0EuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 00:50:08 -0400
Message-ID: <4F7146EA.1030305@zytor.com>
Date: Mon, 26 Mar 2012 21:49:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Michael Davidson <md@google.com>
Subject: Re: [PATCH 2/6] trace: add support for 32 bit compat syscalls on
 x86_64
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com> <1332787168-20457-3-git-send-email-vnagarnaik@google.com>
In-Reply-To: <1332787168-20457-3-git-send-email-vnagarnaik@google.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 11:39 AM, Vaibhav Nagarnaik wrote:
> +/*
> + * syscall metadata for 32 bit compatible system calls
> + *
> + * The metadata entries are in the same order as the system call table
> + * but this is just to make it easier to check them for completeness
> + * and correctness.
> + */
> +
> +COMPAT_SYSCALL_METADATA0(restart_syscall)
> +COMPAT_SYSCALL_METADATA1(exit, int, error_code)
   [...]
> +COMPAT_SYSCALL_METADATA5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg, unsigned int, vlen, unsigned int, flags, struct timespec __user *, timeout)

> +/*
> + * This is truly horrible.

Yes, it is.  How on Earth do you expect the above to ever be maintained?

> + *
> + * There is no header file that defines a *complete* set of 32 bit system
> + * call numbers (unistd_32.h only defines ones that are currently exported
> + * to user space and omits lots of old system calls that are still implemented
> + * by the kernel.

> + * There is also no table that can be used to map a system call number into
> + * the canonical name of that system call.

arch/x86/syscalls has all of those.  If it's not in there, it doesn't
exist, because that's where the system call table comes from.

	-hpa
