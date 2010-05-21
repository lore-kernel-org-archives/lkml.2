Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab0EUJk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:40:59 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35765 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0EUJk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:40:56 -0400
Content-Type: text/plain; charset=UTF-8
Cc: fweisbec <fweisbec@gmail.com>, mingo <mingo@elte.hu>,
       rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/14] tracing: add compat syscall support v3
From: Ian Munsie <imunsie@au1.ibm.com>
To: Jason Baron <jbaron@redhat.com>
In-reply-to: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Date: Fri, 21 May 2010 19:40:21 +1000
Message-Id: <1274433809-sup-5031@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

I'm currently in the process of implementing syscall tracepoints for
PowerPC, and a considerable amount of my work is going to end up
requiring these patches of yours. I've reviewed and tested your patches
(and spent a good chunk of time rebasing them on top of
tip/tracing/core) and they all seem pretty good.

I *particularly* like the way in which they prevent ftrace syscalls from
reporting that sys_swapoff was constantly firing on x86_64 kernels with
a 32bit userspace ;)

Anyway, I'm just wondering if you have an ETA for the v4 patchset to
address the remaining issues that Frederic raised so that they can be
merged.

Cheers,
-Ian

Excerpts from Jason Baron's message of Wed Mar 17 04:46:08 +1100 2010:
> Hi,
> 
> Re-post to add infrastructure for compat syscall event tracing support. This
> patch series also adds x86_64 arch specific support as an example consumer
> of the new infrastructure.
> 
> Arches can request compat syscall tracing by setting: 
> __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS, if CONFIG_COMPAT and CONFIG_FTRACE_SYSCALLS
> are set. Arches then need to implement the following interfaces:
> 
> 1) int is_compat_task(void);
>   - most arches seem to have this already
> 2) unsigned long arch_compat_syscall_addr(int nr);
>   - returns a pointer to the compat syscall entry corresponding to syscall 'nr'
> 3) int NR_syscalls_compat;
>   - number of entries in the compat syscall table.
