Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab1GZGUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:20:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43387 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1GZGUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:20:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1107241223560.2702@ionos>
References: <alpine.LFD.2.02.1107241223560.2702@ionos>
Date: Tue, 26 Jul 2011 14:20:32 +0800
Message-ID: <CAM2zO=AiMC1fnnu7idoH9OXcsKxKtpZ=a5yBeHUBWRZs2ssmKg@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0-rt3
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 6:33 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.0-rt3 release.

Get below bug when I switch tracer between 'function' and 'preemptirqoff'.

[  112.408041] BUG: sleeping function called from invalid context at
kernel/rtmutex.c:645
[  112.408045] in_atomic(): 1, irqs_disabled(): 1, pid: 2213, name: bash
[  112.408048] Pid: 2213, comm: bash Not tainted 3.0.0-rt3-00239-g05a16b8 #3
[  112.408051] Call Trace:
[  112.408059]  [<c15bddb4>] ? printk+0x1d/0x21
[  112.408064]  [<c1036276>] __might_sleep+0xe6/0x110
[  112.408068]  [<c15c048c>] rt_spin_lock+0x1c/0x40
[  112.408072]  [<c10e3087>] free_hot_cold_page+0x87/0x250
[  112.408075]  [<c10e3285>] __free_pages+0x35/0x40
[  112.408078]  [<c10e32c4>] free_pages+0x34/0x40
[  112.408082]  [<c10b3200>] free_buffer_page+0x10/0x20
[  112.408085]  [<c10b5614>] ring_buffer_resize+0x144/0x410
[  112.408089]  [<c10bb0ff>] tracing_set_tracer+0x16f/0x250
[  112.408093]  [<c127c116>] ? __copy_from_user_ll+0x16/0xf0
[  112.408096]  [<c10bb248>] tracing_set_trace_write+0x68/0x90
[  112.408101]  [<c124f846>] ? apparmor_file_permission+0x16/0x20
[  112.408105]  [<c12206f4>] ? security_file_permission+0x24/0xb0
[  112.408109]  [<c11207cc>] ? rw_verify_area+0x6c/0x130
[  112.408112]  [<c1120e0d>] ? sys_write+0x1d/0x70
[  112.408115]  [<c1121f51>] ? fget_light+0x11/0xd0
[  112.408118]  [<c1120b52>] vfs_write+0xa2/0x170
[  112.408121]  [<c10bb1e0>] ? tracing_set_tracer+0x250/0x250
[  112.408123]  [<c1121f56>] ? fget_light+0x16/0xd0
[  112.408127]  [<c1120e32>] sys_write+0x42/0x70
[  112.408130]  [<c15c6cdf>] sysenter_do_call+0x12/0x2d

-- 
Only stand for myself
