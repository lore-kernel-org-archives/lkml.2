Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2IYTmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:42:54 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50327 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab2IYTmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:42:53 -0400
Date: Tue, 25 Sep 2012 12:42:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
Cc: linux-kernel@vger.kernel.org, arekm@pld-linux.org, baggins@pld-linux.org
Subject: Re: [3.5.4] rcu_sched self-detected stall on CPU { 1}  (t=54862991
 jiffies)
Message-ID: <20120925194250.GA25922@kroah.com>
References: <1377033.GMb6SBRYYa@pawels>
 <2429639.puuGestFgj@localhost>
 <20120925164454.GA22330@kroah.com>
 <1728491.bnoskTaLZT@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1728491.bnoskTaLZT@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 07:04:19PM +0200, Paweł Sikora wrote:
> On Tuesday 25 of September 2012 09:44:54 Greg KH wrote:
> > On Tue, Sep 25, 2012 at 06:31:36PM +0200, Paweł Sikora wrote:
> > > On Monday 24 of September 2012 10:36:33 Greg KH wrote:
> > > > On Mon, Sep 24, 2012 at 10:05:23AM +0200, Paweł Sikora wrote:
> > > > > Hi,
> > > > > 
> > > > > with the new stable line i'm observing strange locks on my old amd-phenom-II mini-server.
> > > > > here's a dmesg:
> > > > 
> > > > Did this show up in 3.5.3?  If not, can you run 'git bisect' to find the
> > > > problem patch?
> > > 
> > > heh, the old good kernel put some light on this issue.
> > > 
> > > Sep 25 08:50:24 nexus kernel: [60330.301639] Clocksource tsc unstable (delta = -474690884 ns)
> > > Sep 25 08:50:24 nexus kernel: [60330.325477] ------------[ cut here ]------------
> > > Sep 25 08:50:24 nexus kernel: [60330.325484] WARNING: at /home/users/builder/rpm/BUILD/kernel-2.6.37.6/linux-2.6.37/net/sched/sch_generic.c:258 dev_watchdog+0x25d/0x270()
> > > Sep 25 08:50:24 nexus kernel: [60330.325486] Hardware name: GA-MA785GMT-UD2H
> > > Sep 25 08:50:24 nexus kernel: [60330.325487] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> > > (...)
> > > Sep 25 08:50:25 nexus kernel: [60330.851093] Switching to clocksource acpi_pm
> > > 
> > > afaics, this amd-phenom cpu does the cpu frequency scaling and causes plain 'tsc' timer
> > > instability which leads to network card watchdog timeout (i can login via local console
> > > while any network traffic is dead). on the recent 3.5.x kernel the 'clocksource unstable'
> > > message appears *after* 'task blocked' flood and there's no clear info about watchog timeout.
> > > currently i'm testing hpet clocksource becasue better tsc modes (constant_tsc, nonstop_tsc)
> > > aren't present in /sys/devices/system/clocksource/clocksource0/available_clocksource while
> > > cpu supports them.
> > 
> > I'm sorry, I don't understand, that's a 2.6.37 kernel you are comparing
> > this to.  Where did this problem show up?  In 3.5.4 where 3.5.3 was
> > fine?
> 
> 'cpu-stall' from topic has appeared in 3.5.2 (after upgrade from 3.4.10).

So, can you run 'git bisect' from 3.4.10 and 3.5.2 to find the commit
causing the problem?

thanks,

greg k-h
