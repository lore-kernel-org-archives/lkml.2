Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2IYREZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:04:25 -0400
Received: from mail.agmk.net ([91.192.224.71]:39634 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826Ab2IYREY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:04:24 -0400
From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arekm@pld-linux.org, baggins@pld-linux.org
Subject: Re: [3.5.4] rcu_sched self-detected stall on CPU { 1}  (t=54862991 jiffies)
Date: Tue, 25 Sep 2012 19:04:19 +0200
Message-ID: <1728491.bnoskTaLZT@localhost>
User-Agent: KMail/4.9.1 (Linux/3.5.4; KDE/4.9.1; x86_64; ; )
In-Reply-To: <20120925164454.GA22330@kroah.com>
References: <1377033.GMb6SBRYYa@pawels> <2429639.puuGestFgj@localhost> <20120925164454.GA22330@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 of September 2012 09:44:54 Greg KH wrote:
> On Tue, Sep 25, 2012 at 06:31:36PM +0200, Paweł Sikora wrote:
> > On Monday 24 of September 2012 10:36:33 Greg KH wrote:
> > > On Mon, Sep 24, 2012 at 10:05:23AM +0200, Paweł Sikora wrote:
> > > > Hi,
> > > > 
> > > > with the new stable line i'm observing strange locks on my old amd-phenom-II mini-server.
> > > > here's a dmesg:
> > > 
> > > Did this show up in 3.5.3?  If not, can you run 'git bisect' to find the
> > > problem patch?
> > 
> > heh, the old good kernel put some light on this issue.
> > 
> > Sep 25 08:50:24 nexus kernel: [60330.301639] Clocksource tsc unstable (delta = -474690884 ns)
> > Sep 25 08:50:24 nexus kernel: [60330.325477] ------------[ cut here ]------------
> > Sep 25 08:50:24 nexus kernel: [60330.325484] WARNING: at /home/users/builder/rpm/BUILD/kernel-2.6.37.6/linux-2.6.37/net/sched/sch_generic.c:258 dev_watchdog+0x25d/0x270()
> > Sep 25 08:50:24 nexus kernel: [60330.325486] Hardware name: GA-MA785GMT-UD2H
> > Sep 25 08:50:24 nexus kernel: [60330.325487] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> > (...)
> > Sep 25 08:50:25 nexus kernel: [60330.851093] Switching to clocksource acpi_pm
> > 
> > afaics, this amd-phenom cpu does the cpu frequency scaling and causes plain 'tsc' timer
> > instability which leads to network card watchdog timeout (i can login via local console
> > while any network traffic is dead). on the recent 3.5.x kernel the 'clocksource unstable'
> > message appears *after* 'task blocked' flood and there's no clear info about watchog timeout.
> > currently i'm testing hpet clocksource becasue better tsc modes (constant_tsc, nonstop_tsc)
> > aren't present in /sys/devices/system/clocksource/clocksource0/available_clocksource while
> > cpu supports them.
> 
> I'm sorry, I don't understand, that's a 2.6.37 kernel you are comparing
> this to.  Where did this problem show up?  In 3.5.4 where 3.5.3 was
> fine?

'cpu-stall' from topic has appeared in 3.5.2 (after upgrade from 3.4.10).
the 3.5.4 also has the same problem as 3.5.2, so i've went back to initial 2.6.37.6
which had worked fine for many months. now i'm pretty sure that all these problems
are related to tsc instability and appears on different kernels in different form.

