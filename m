Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab2DKDVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 23:21:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53395 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018Ab2DKDVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 23:21:36 -0400
Message-ID: <4F84F895.4080101@zytor.com>
Date: Tue, 10 Apr 2012 20:20:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
Subject: Re: [PATCH v15 04/13] arch/x86: add syscall_get_arch to syscall.h
References: <1331781125-15658-1-git-send-email-wad@chromium.org> <1331781125-15658-5-git-send-email-wad@chromium.org> <4F6F7362.6030402@zytor.com> <CABqD9hZgnrKFY_Wei-ysU=Dy7Og2iEemnqPvcQ14M0+vL65gHQ@mail.gmail.com>
In-Reply-To: <CABqD9hZgnrKFY_Wei-ysU=Dy7Og2iEemnqPvcQ14M0+vL65gHQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 08:13 PM, Will Drewry wrote:
> On Sun, Mar 25, 2012 at 2:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 03/14/2012 08:11 PM, Will Drewry wrote:
>>>
>>> +static inline int syscall_get_arch(struct task_struct *task,
>>> +                                struct pt_regs *regs)
>>> +{
>>> +#ifdef CONFIG_IA32_EMULATION
>>> +     /*
>>> +      * TS_COMPAT is set for 32-bit syscall entries and then
>>> +      * remains set until we return to user mode.
>>> +      *
>>> +      * TIF_IA32 tasks should always have TS_COMPAT set at
>>> +      * system call time.
>>> +      */
>>> +     if (task_thread_info(task)->status & TS_COMPAT)
>>> +             return AUDIT_ARCH_I386;
>>> +#endif
>>> +     return AUDIT_ARCH_X86_64;
>>> +}
>>>  #endif       /* CONFIG_X86_32 */
>>>
>>>  #endif       /* _ASM_X86_SYSCALL_H */
>>
>> Just one FYI on this: after the x32 changes are upstream this can be
>> implemented in terms of is_ia32_task().
> 
> Now that I've seen is_ia32_task(), it appears to be exactly the same as above:
> (1)  If we're x86_32, it's ia32
> (2)  If we're x86_64, ia32 == !!(status & TS_COMPAT)
> (3)  Otherwise, it's x86_64, including x32
> 
> Am I missing something? Should is_ia32_task(void) take a task_struct?
> Right now, I don't see any reason to change the code, as posted, but
> maybe I am mis-reading?
> 

Sorry, answered the wrong question.  Yes, it is the same as above...
just wandered if we could centralize this test.  It might indeed make
sense to provide general predicates which take a task pointer.

	-hpa

