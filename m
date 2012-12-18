Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab2LRBGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:06:32 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37608 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2LRBG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:06:29 -0500
MIME-Version: 1.0
In-Reply-To: <50CFA3C1.3040004@tilera.com>
References: <1355546091-32537-1-git-send-email-simon.marchi@polymtl.ca>
 <50CF510E.6050406@tilera.com> <CAFXXi0m3rHg7P+GetLKv_cwp5+c5xsmbJ8LM5CTLGT39JhBmzA@mail.gmail.com>
 <50CFA3C1.3040004@tilera.com>
From: Simon Marchi <simon.marchi@polymtl.ca>
Date: Mon, 17 Dec 2012 20:05:58 -0500
X-Google-Sender-Auth: dPEpLA3FtiYsE-Sv0QUfNXWkr8g
Message-ID: <CAFXXi0=OJEnj6bDxagV0VyEW6EYXbL1mJgBGMOYz-jsyfa+JqQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] arch/tile: implement user_regset interface on tilegx
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 5:59 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 12/17/2012 5:07 PM, Simon Marchi wrote:
>>> I think with this support added, we have all the prerequisites to add "select HAVE_ARCH_TRACEHOOK" under "config TILE" in arch/tile/Kconfig, so we might as well do that too.  That will enable PTRACE_GETREGSET and PTRACE_SETREGSET, as well as /proc/PID/syscall, so why not?
>> This is indeed my objective ;), and it is an intermediate objective to
>> add support for HAVE_SYSCALL_TRACEPOINTS. If we look at arch/Kconfig,
>> just above HAVE_ARCH_TRACEHOOK, we still have
>>
>> TIF_SYSCALL_TRACE       calls tracehook_report_syscall_{entry,exit}
>> TIF_NOTIFY_RESUME       calls tracehook_notify_resume()
>> signal delivery         calls tracehook_signal_handler()
>
> I believe we do properly support TIF_SYSCALL_TRACE; see arch/tile/kernel/intvec_64.S.  Likewise TIF_NOTIFY_RESUME; see do_work_pending() in arch/tile/kernel/process.c.  And signal delivery seems to be handled in a platform-independent way now; see kernel/signal.c.

TIF_SYSCALL_TRACE is handled, but it doesn't call
tracehook_report_syscall_{entry,exit} as specified. The two others
seem handled like you said.

> My only comment on the revised patch is that I believe you should #include <arch/chip.h>, not <uapi/arch/chip.h>.  Source code (.c files) doesn't seem to use the <uapi/> prefix.

Oh, I didn't know the include path contained arch/tile/include/uapi
directly. Fixing it.
