Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2G0QUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:20:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab2G0QUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:20:48 -0400
Date: Fri, 27 Jul 2012 12:20:38 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120727162038.GD12244@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20120724203613.GA9637@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724203613.GA9637@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 04:36:13PM -0400, Dave Jones wrote:
 > Linus tree as of 5fecc9d8f59e765c2a48379dd7c6f5cf88c7d75a
 > 
 > 	Dave
 > 
 > ======================================================
 > [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
 > 3.5.0+ #122 Not tainted
 > ------------------------------------------------------
 > trinity-child2/5327 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 > blocked:  (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff8109762b>] posix_cpu_timer_del+0x2b/0xe0
 > 
 > and this task is already holding:
 > blocked:  (&(&new_timer->it_lock)->rlock){-.-...}, instance: ffff880143bce170, at: [<ffffffff81093d49>] __lock_timer+0x89/0x1f0
 > which would create a new lock dependency:
 >  (&(&new_timer->it_lock)->rlock){-.-...} -> (tasklist_lock){.+.+..}
 > 
 > but this new dependency connects a HARDIRQ-irq-safe lock:
 >  (&(&new_timer->it_lock)->rlock){-.-...}
 > ... which became HARDIRQ-irq-safe at:

Shall I start bisecting this ? I can trigger it very easily, but if you
can give me a set of commits to narrow down, it'll speed up the bisection.

	Dave
