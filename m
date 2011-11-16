Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1KPOsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:48:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:58604 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1KPOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:48:13 -0500
Date: Wed, 16 Nov 2011 15:48:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH -rt] printk: Don't emit console_cpu_notify() for
 CPU_DYING
In-Reply-To: <1321453190.4181.21.camel@frodo>
Message-ID: <alpine.LFD.2.02.1111161547560.4902@ionos>
References: <20111116094219.GA9281@zhy> <1321453190.4181.21.camel@frodo>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011, Steven Rostedt wrote:

> On Wed, 2011-11-16 at 17:42 +0800, Yong Zhang wrote:
> > Otherwise we will get below warning:
> > 
> > BUG: sleeping function called from invalid context at /build/linux/kernel/rtmutex.c:645
> > in_atomic(): 1, irqs_disabled(): 1, pid: 1054, name: migration/9
> > no locks held by migration/9/1054.
> > irq event stamp: 36
> > hardirqs last  enabled at (35): [<ffffffff815f5b50>] _raw_spin_unlock_irq+0x30/0x70
> > hardirqs last disabled at (36): [<ffffffff810b7eaf>] stop_machine_cpu_stop+0x8f/0x110
> > softirqs last  enabled at (0): [<ffffffff81051b53>] copy_process+0x6d3/0x1640
> > softirqs last disabled at (0): [<          (null)>]           (null)
> > Pid: 1054, comm: migration/9 Not tainted 3.2.0-rc1-rt2-11312-gbf51260-dirty #12
> > Call Trace:
> 
> Thomas, doesn't printk not print to serial in atomic contexts? Or did
> that change?

Not that I know of.
