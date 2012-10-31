Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2JaHEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:04:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53300 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2JaHEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:04:42 -0400
MIME-Version: 1.0
In-Reply-To: <tip-8781915ad2716adcd8cd5cc52cee791fc8b00fdf@git.kernel.org>
References: <1347461277-25302-1-git-send-email-elezegarcia@gmail.com>
	<tip-8781915ad2716adcd8cd5cc52cee791fc8b00fdf@git.kernel.org>
Date: Wed, 31 Oct 2012 09:04:40 +0200
X-Google-Sender-Auth: bE2jzjNfdgPCdfMuJbObSOjpie0
Message-ID: <CAOJsxLF2tgLDn0pcTaisd0N4c+4Jxi=gmV1qK+7MSc6=QoyBkA@mail.gmail.com>
Subject: Re: [tip:perf/core] trace: Move trace event enable from fs_initcall
 to core_initcall
From: Pekka Enberg <penberg@kernel.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        elezegarcia@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ezequiel,

On Thu, Sep 27, 2012 at 8:49 AM, tip-bot for Ezequiel Garcia
<elezegarcia@gmail.com> wrote:
> Commit-ID:  8781915ad2716adcd8cd5cc52cee791fc8b00fdf
> Gitweb:     http://git.kernel.org/tip/8781915ad2716adcd8cd5cc52cee791fc8b00fdf
> Author:     Ezequiel Garcia <elezegarcia@gmail.com>
> AuthorDate: Wed, 12 Sep 2012 11:47:57 -0300
> Committer:  Steven Rostedt <rostedt@goodmis.org>
> CommitDate: Mon, 24 Sep 2012 14:13:02 -0400
>
> trace: Move trace event enable from fs_initcall to core_initcall
>
> This patch splits trace event initialization in two stages:
>  * ftrace enable
>  * sysfs event entry creation
>
> This allows to capture trace events from an earlier point
> by using 'trace_event' kernel parameter and is important
> to trace boot-up allocations.
>
> Note that, in order to enable events at core_initcall,
> it's necessary to move init_ftrace_syscalls() from
> core_initcall to early_initcall.
>
> Link: http://lkml.kernel.org/r/1347461277-25302-1-git-send-email-elezegarcia@gmail.com
>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

So what's still needed for perf to be able to trace early boot slab
allocations like kmemtrace used to be able to do?

                        Pekka
