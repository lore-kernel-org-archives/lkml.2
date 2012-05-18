Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab2ERAph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:45:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43913 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab2ERApg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:45:36 -0400
Message-ID: <4FB59BAD.1020505@gmail.com>
Date: Thu, 17 May 2012 17:45:33 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ralf Baechle <ralf@linux-mips.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com> <CA+55aFy+XOc350sVuLKDHAaKtz9GdLcVmjxs98N8XLTK4zmMYg@mail.gmail.com> <4FB59474.2020505@zytor.com> <4FB597F3.3060909@gmail.com> <4FB59858.5030800@zytor.com>
In-Reply-To: <4FB59858.5030800@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 05:31 PM, H. Peter Anvin wrote:
> On 05/17/2012 05:29 PM, David Daney wrote:
>>
>> I don't know if that answers your question though.
>>
>
> Not in the slightest.  The question is how on Earth struct msqid64_ds
> isn't botched on MIPS.

It is botched.

#if defined(CONFIG_32BIT) && defined(CONFIG_CPU_LITTLE_ENDIAN) come out 
in the userspace header file.

On mips it would appear that asm/msgbuf.h is not unique in this manner:

# grep CONFIG *.h
fcntl.h:#ifdef CONFIG_32BIT
fcntl.h:#endif /* CONFIG_32BIT */
ioctls.h:#define TIOCSERCONFIG	0x5488
msgbuf.h:#if defined(CONFIG_32BIT) && !defined(CONFIG_CPU_LITTLE_ENDIAN)
msgbuf.h:#if defined(CONFIG_32BIT) && defined(CONFIG_CPU_LITTLE_ENDIAN)
msgbuf.h:#if defined(CONFIG_32BIT) && !defined(CONFIG_CPU_LITTLE_ENDIAN)
msgbuf.h:#if defined(CONFIG_32BIT) && defined(CONFIG_CPU_LITTLE_ENDIAN)
msgbuf.h:#if defined(CONFIG_32BIT) && !defined(CONFIG_CPU_LITTLE_ENDIAN)
msgbuf.h:#if defined(CONFIG_32BIT) && defined(CONFIG_CPU_LITTLE_ENDIAN)
ptrace.h:#ifdef CONFIG_32BIT
ptrace.h:#ifdef CONFIG_CPU_HAS_SMARTMIPS
ptrace.h:#ifdef CONFIG_MIPS_MT_SMTC
ptrace.h:#endif /* CONFIG_MIPS_MT_SMTC */
ptrace.h:#ifdef CONFIG_CPU_CAVIUM_OCTEON
resource.h:#ifdef CONFIG_32BIT
siginfo.h:#ifdef CONFIG_32BIT
siginfo.h:#ifdef CONFIG_64BIT
swab.h:#ifdef CONFIG_CPU_MIPSR2
swab.h: * Having already checked for CONFIG_CPU_MIPSR2, enable the
swab.h:#ifdef CONFIG_64BIT
swab.h:#endif /* CONFIG_64BIT */
swab.h:#endif /* CONFIG_CPU_MIPSR2 */

David Daney
