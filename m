Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab0LUPMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 10:12:47 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:51327 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0LUPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 10:12:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=upArvtsMCIRzTCizRgDgS+ZTpXa21nWhbiSKGwqoMLq8nNqr4HZMZloz9e1j/tiHUy
         ytdlKfLz8suJ+Fum7Aub5jOVp/XhRfRYz/sUuzlK7zgkNVC1AQrga/X4+ofU/mVAmQBt
         y4oArBdc4+VseWdgxdakELvx/Q1ofeHPNivKU=
Date: Tue, 21 Dec 2010 16:12:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 11/15] x86: Nohz task support
Message-ID: <20101221151239.GJ1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-12-git-send-email-fweisbec@gmail.com>
 <1292862199.5021.32.camel@laptop>
 <20101221013019.GK1715@nowhere>
 <1292918729.5021.195.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292918729.5021.195.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 09:05:29AM +0100, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 02:30 +0100, Frederic Weisbecker wrote:
> > On Mon, Dec 20, 2010 at 05:23:19PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > > 
> > > > Implement the thread flag, syscalls and exception hooks for
> > > > nohz task support.
> > > > 
> > > 
> > > I saw:
> > >  - syscall
> > >  - do_int3
> > >  - do_debug (int1)
> > >  - #PF
> > > 
> > > So where's all other interrupts?
> > 
> > No need to handle them.
> > 
> > We have:
> > 
> > rcu_irq_enter() rcu_irq_exit() rcu_nmi_enter() rcu_nmi_exit()
> > and they already act as pauses into extended quiescent states, which
> > is enough for our needs.
> 
> Oh, and RCU is the only thing you need to worry about is it?

It seems that I need to hook there for the time accounting now
and take the time spent in user, syscalls, exceptions and irq as
system time. But instead of doing that from the tick, I need
to compute the deltas from the hooks, and also handle the fact
the tick can be restarted any time and so...

Plus the update_curr() thing and so on...
