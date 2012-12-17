Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2LQW7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:59:17 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:16952 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2LQW7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:59:16 -0500
Message-ID: <50CFA3C1.3040004@tilera.com>
Date: Mon, 17 Dec 2012 17:59:13 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Simon Marchi <simon.marchi@polymtl.ca>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] arch/tile: implement user_regset interface on tilegx
References: <1355546091-32537-1-git-send-email-simon.marchi@polymtl.ca> <50CF510E.6050406@tilera.com> <CAFXXi0m3rHg7P+GetLKv_cwp5+c5xsmbJ8LM5CTLGT39JhBmzA@mail.gmail.com>
In-Reply-To: <CAFXXi0m3rHg7P+GetLKv_cwp5+c5xsmbJ8LM5CTLGT39JhBmzA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 5:07 PM, Simon Marchi wrote:
>> I think with this support added, we have all the prerequisites to add "select HAVE_ARCH_TRACEHOOK" under "config TILE" in arch/tile/Kconfig, so we might as well do that too.  That will enable PTRACE_GETREGSET and PTRACE_SETREGSET, as well as /proc/PID/syscall, so why not?
> This is indeed my objective ;), and it is an intermediate objective to
> add support for HAVE_SYSCALL_TRACEPOINTS. If we look at arch/Kconfig,
> just above HAVE_ARCH_TRACEHOOK, we still have
>
> TIF_SYSCALL_TRACE       calls tracehook_report_syscall_{entry,exit}
> TIF_NOTIFY_RESUME       calls tracehook_notify_resume()
> signal delivery         calls tracehook_signal_handler()

I believe we do properly support TIF_SYSCALL_TRACE; see arch/tile/kernel/intvec_64.S.  Likewise TIF_NOTIFY_RESUME; see do_work_pending() in arch/tile/kernel/process.c.  And signal delivery seems to be handled in a platform-independent way now; see kernel/signal.c.

My only comment on the revised patch is that I believe you should #include <arch/chip.h>, not <uapi/arch/chip.h>.  Source code (.c files) doesn't seem to use the <uapi/> prefix.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

