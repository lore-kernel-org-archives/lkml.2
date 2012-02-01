Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2BAXSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:18:06 -0500
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:59125 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab2BAXSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:18:02 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Feb 2012 18:17:50 EST
From: Tim Sander <tstone@vlsi.informatik.tu-darmstadt.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [ANNOUNCE] 3.0.14-rt31 - ksoftirq running wild - FEC ethernet driver to blame? Yep
Date: Thu, 2 Feb 2012 00:11:02 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc1-00514-gd3712b9; KDE/4.6.5; x86_64; ; )
Cc: Tim Sander <tim.sander@hbm.com>, RT <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Tim Sander <tstone@iss.tu-darmstadt.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        Micha Nelissen <micha@neli.hopto.org>,
        Holger Brunck <holger.brunck@keymile.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com> <201201251031.48983.tim.sander@hbm.com> <1328128063.5882.80.camel@gandalf.stny.rr.com>
In-Reply-To: <1328128063.5882.80.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202020011.03253.tstone@vlsi.informatik.tu-darmstadt.de>
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.2.1.225714
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven
> Is the system still usable when this happens? If so, can you configure
> in ftrace, and run a trace on what ksoftirq is doing:
Well its slooooooooooooooooow since its only 5% of a 500Mhz arm v6 cpu.
So i can easy type faster than this thing echo characters on a serial console :-)
> mkdir /debug
> mount -t debugfs nodev /debug
> cd /debug/tracing
> echo <pid-of-ksoftirq> > set_ftrace_pid
> echo function > current_tracer
> cat trace
Well i tried the complete function tracer and i think systemload is just to high 
for this system but i will give it a try as soon as i see this error again.

When toying around with the hw debugger i think it runs somehow into do_coredump 
when this error hits and then somehow loops but since i was feeding the wrong 
symbol table to my hw debugger all this stuff looked even weirder today 8-/.

I was also toying around with setting the phy timeout in the driver and 
hacking in the phy interrupt, but nothing conclusive.

Best regards
Tim

dmesg output with phy irq enabled, either my hackish interrupt setting is not
working or the fec driver has a problem with phy interrupts... dunno:

nf_conntrack version 0.5.0 (1979 buckets, 7916 max)
fec_stop : Graceful transmit stop did not complete !
sched: RT throttling activated
FEC: MDIO read timeout
PHY: 1:00 - Link is Down
irq 103: nobody cared (try booting with the "irqpoll" option)
Backtrace: 
[<c002de30>] (dump_backtrace+0x0/0x110) from [<c024d780>] (dump_stack+0x18/0x1c)
 r6:00000000 r5:c794a2e0 r4:c031856c r3:00000000
[<c024d768>] (dump_stack+0x0/0x1c) from [<c0070930>] (__report_bad_irq.clone.5+0x2c/0xdc)
[<c0070904>] (__report_bad_irq.clone.5+0x0/0xdc) from [<c0070bf0>] (note_interrupt+0x19c/0x244)
 r5:c794a2e0 r4:c0318544
[<c0070a54>] (note_interrupt+0x0/0x244) from [<c006f724>] (irq_thread+0xf0/0x1f4)
[<c006f634>] (irq_thread+0x0/0x1f4) from [<c0057298>] (kthread+0x8c/0x94)
[<c005720c>] (kthread+0x0/0x94) from [<c00413d4>] (do_exit+0x0/0x2d8)
 r7:00000013 r6:c00413d4 r5:c005720c r4:c7bd9904
handlers:
[<c006f4c8>] irq_default_primary_handler threaded [<c01a1660>] phy_interrupt
Disabling IRQ #103
FEC: MDIO write timeout
init: avahi-autoip main process (423) terminated with status 1
init: avahi-autoip main process ended, respawning
eth0: Freescale FEC PHY driver [Micrel KS8041] (mii_bus:phy_addr=1:00, irq=103)
ADDRCONF(NETDEV_UP): eth0: link is not ready
PHY: 1:00 - Link is Up - 100/Full
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

