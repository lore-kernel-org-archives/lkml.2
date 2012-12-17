Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2LQWID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:08:03 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41934 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2LQWIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:08:01 -0500
MIME-Version: 1.0
In-Reply-To: <50CF510E.6050406@tilera.com>
References: <1355546091-32537-1-git-send-email-simon.marchi@polymtl.ca> <50CF510E.6050406@tilera.com>
From: Simon Marchi <simon.marchi@polymtl.ca>
Date: Mon, 17 Dec 2012 17:07:30 -0500
X-Google-Sender-Auth: eufAo8fwrpXQ3zCkQfncj1L0bxg
Message-ID: <CAFXXi0m3rHg7P+GetLKv_cwp5+c5xsmbJ8LM5CTLGT39JhBmzA@mail.gmail.com>
Subject: Re: [PATCH 1/3] arch/tile: implement user_regset interface on tilegx
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 12:06 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 12/14/2012 11:34 PM, Simon Marchi wrote:
>> This is an implementation of user_regset for the tilegx architecture. It
>> reuses the basic blocks that were already there.
>
> Thanks, Simon!  A couple of comments:
>
> I encourage you to respin this for tilepro as well as tilegx, since it's going to be trivial to make it happen.  Just take away all yours ifdefs, and use #include <arch/chip.h> and CHIP_ARCH_NAME instead of the string "tilegx".  It's worth it just to avoid the ifdefs in the code :-)

Ok, I will send a v2 with this soon.

> I think with this support added, we have all the prerequisites to add "select HAVE_ARCH_TRACEHOOK" under "config TILE" in arch/tile/Kconfig, so we might as well do that too.  That will enable PTRACE_GETREGSET and PTRACE_SETREGSET, as well as /proc/PID/syscall, so why not?

This is indeed my objective ;), and it is an intermediate objective to
add support for HAVE_SYSCALL_TRACEPOINTS. If we look at arch/Kconfig,
just above HAVE_ARCH_TRACEHOOK, we still have

TIF_SYSCALL_TRACE       calls tracehook_report_syscall_{entry,exit}
TIF_NOTIFY_RESUME       calls tracehook_notify_resume()
signal delivery         calls tracehook_signal_handler()

that we need to implement.

> --
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
>
