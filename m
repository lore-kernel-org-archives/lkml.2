Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab0LUIFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 03:05:42 -0500
Received: from canuck.infradead.org ([134.117.69.58]:36812 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612Ab0LUIFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 03:05:40 -0500
Subject: Re: [RFC PATCH 11/15] x86: Nohz task support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <20101221013019.GK1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-12-git-send-email-fweisbec@gmail.com>
	 <1292862199.5021.32.camel@laptop>  <20101221013019.GK1715@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Dec 2010 09:05:29 +0100
Message-ID: <1292918729.5021.195.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 02:30 +0100, Frederic Weisbecker wrote:
> On Mon, Dec 20, 2010 at 05:23:19PM +0100, Peter Zijlstra wrote:
> > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > 
> > > Implement the thread flag, syscalls and exception hooks for
> > > nohz task support.
> > > 
> > 
> > I saw:
> >  - syscall
> >  - do_int3
> >  - do_debug (int1)
> >  - #PF
> > 
> > So where's all other interrupts?
> 
> No need to handle them.
> 
> We have:
> 
> rcu_irq_enter() rcu_irq_exit() rcu_nmi_enter() rcu_nmi_exit()
> and they already act as pauses into extended quiescent states, which
> is enough for our needs.

Oh, and RCU is the only thing you need to worry about is it?
