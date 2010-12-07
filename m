Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0LGHqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 02:46:40 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43794 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0LGHqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:46:39 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 7 Dec 2010 08:46:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Adrian Knoth <adi@drcomp.erfurt.thur.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6.33.7-rt, epoll] kerneloops with FFADO on RT kernel
Message-ID: <20101207084626.76b386cb@stein>
In-Reply-To: <4CFCE319.6060808@drcomp.erfurt.thur.de>
References: <4CFCE319.6060808@drcomp.erfurt.thur.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 06 Adrian Knoth wrote at linux1394-devel:
> I just noticed there is a kerneloops when using FFADO on 2.6.33.7-rt:
> 
> Kernel failure message 13:
> BUG: sleeping function called from invalid context at kernel/rtmutex.c:707
> pcnt: 1 0 in_atomic(): 1, irqs_disabled(): 0, pid: 10, name: sirq-tasklet/0
> Pid: 10, comm: sirq-tasklet/0 Not tainted 2.6.33.7-rt29rt #3
> Call Trace:
>  [<c1025318>] __might_sleep+0xcc/0xd4
>  [<c10593a5>] T.503+0x26/0x5f
>  [<c12365f2>] rt_spin_lock+0x8/0xa
>  [<c10d8b9a>] T.543+0x1e/0xad
>  [<c10d89b3>] ? ep_poll_wakeup_proc+0x0/0x1a
>  [<c102bc6f>] ? try_to_wake_up+0x374/0x388
>  [<c10d8c99>] ep_poll_safewake+0x28/0x4b
>  [<c10d91b4>] ep_poll_callback+0x9c/0xa6
>  [<c1022502>] __wake_up_common+0x34/0x5c
>  [<c1029cec>] __wake_up+0x26/0x34
>  [<f813ffdc>] queue_event+0x66/0x6f [firewire_core]
>  [<f8140c23>] handle_request+0x11d/0x157 [firewire_core]
>  [<f8144302>] fw_core_handle_request+0x32b/0x395 [firewire_core]
[...]
> I have plenty of those, one per second, but I'm not sure if there's
> really something wrong or if this "bug" is introduced by the RT
> patchset. FFADO works fine, and 2.6.33 is also pretty old wrt Juju, so
> this might all be noise.

There were issues with epoll in the mainline kernel before, but I
don't remember which kernels were affected.  But it could also be an
-rt specific problem.

We are definitely entitled to use wake_up_interruptible() in atomic
context (here: tasklet context), i.e. it is not a firewire bug.
-- 
Stefan Richter
-=====-==-=- ==-- --===
http://arcgraph.de/sr/
