Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403Ab2FHCeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:34:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab2FHCea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:34:30 -0400
Date: Thu, 7 Jun 2012 22:34:20 -0400
From: Dave Jones <davej@redhat.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Marc Dionne <marc.c.dionne@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120608023420.GD7191@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Francois Romieu <romieu@fr.zoreil.com>,
	Marc Dionne <marc.c.dionne@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120530214809.GA19223@redhat.com>
 <alpine.LFD.2.02.1205310938080.3231@ionos>
 <20120601225754.GA25281@electric-eye.fr.zoreil.com>
 <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com>
 <20120605231550.GA20981@electric-eye.fr.zoreil.com>
 <20120606014656.GA24870@redhat.com>
 <20120606054251.GA24467@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606054251.GA24467@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 07:42:51AM +0200, Francois Romieu wrote:

 > My sequence was:
 > 
 > echo 0 > tracing_on
 > echo nop > current_tracer
 > echo 10000 > buffer_size_kb
 > echo function > current_tracer
 > echo rtl* > set_ftrace_filter
 > echo r8169* >> set_ftrace_filter
 > echo tick_nohz_stop_sched_tick >> set_ftrace_filter
 > 
 > I only enabled tracing_on right before 'ip link ... up'.

Ok. This was a bit of a pain to trace, as I can't trigger the NOHZ message
when I bring up/down the interface by hand. It only seems to happen
during boot now for some reason. So I modified the networking ifup scripts
to start/stop the logging. It's still a pain, because there are two NICs
in the affected machine, so everything happens twice.
It also seems to have started too early & finished too late.. oh well.
hopefully you can get something interesting out of it.

 > tick_nohz_stop_sched_tick fills the log rather fast.

I don't have that symbol for some reason.

The log is still huge though. (68M uncompressed) at http://www.codemonkey.org.uk/junk/r8169-trace.txt.xz

Here's the order of events on that boot...

[   53.086040] r8169 0000:01:00.0: eth0: link down
[   53.086441] r8169 0000:01:00.0: eth0: link down
[   53.086545] NOHZ: local_softirq_pending 08
[   53.113025] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   54.773637] r8169 0000:01:00.0: eth0: link up
[   54.783210] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   64.941664] r8169 0000:05:00.0: eth1: link down
[   64.941748] r8169 0000:05:00.0: eth1: link down
[   64.941792] NOHZ: local_softirq_pending 08
[   64.968326] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   67.948677] r8169 0000:05:00.0: eth1: link up
[   67.961872] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready


	Dave
