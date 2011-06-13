Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1FMDaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 23:30:20 -0400
Received: from mail.globalsuite.net ([69.46.103.200]:43769 "EHLO
	mail.globalsuite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab1FMDaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 23:30:18 -0400
X-Greylist: delayed 3598 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jun 2011 23:30:18 EDT
X-AuditID: c0a8013c-b7bc0ae0000012fe-6b-4df57638d369
Subject: Re: rcu_sched_state detected stall on CPU 0, 3.0-rc2
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <20110612235555.GD11580@hexapodia.org>
References: <20110612195856.GA11580@hexapodia.org>
	 <20110612231143.GC11580@hexapodia.org>
	 <20110612235555.GD11580@hexapodia.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Sun, 12 Jun 2011 22:30:05 -0400
Message-ID: <1307932206.22348.677.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAARhMmGM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-12 at 16:55 -0700, Andy Isaacson wrote:
> Let's CC netdev and linux-pm since this is obviously a suspend issue,
> and may have something to do with ethtool.
> 
> On Sun, Jun 12, 2011 at 04:11:43PM -0700, Andy Isaacson wrote:
> > On Sun, Jun 12, 2011 at 12:58:56PM -0700, Andy Isaacson wrote:
> > > My Thinkpad x201s threw some errors (?) a few minutes after resuming
> > > from suspend-to-ram this morning.
> > > 
> > > [56415.672140] INFO: rcu_sched_state detected stall on CPU 0 (t=15000 jiffies)
> > > 
> > > Nothing jumps out of the backtraces at me.  Full dmesg and config
> > > attached.  This was my first StR since upgrading from 2.6.39, let's see
> > > if it fails again when I suspend after sending this email. :)
> > 
> > I haven't had a fully successful StR cycle yet (in 5 tries), although I
> > can't pin them all on RCU.  On try 2 it hung completely about 10 seconds
> > after I unlocked the screensaver, on try 3 it came back to a black
> > console, and on try 4 it didn't suspend at all (blinking moon LED but
> > battery LED and CPU fan still on).
> 
> Of course now that I'm trying to debug, I am seeing many successful
> suspend-resume cycles.  I don't see any signs of difference between the
> cases that hung and the cases that are now succeeding.
> 
> CCing netdev, because I suspend by running pm-suspend, and in at least
> one failure, an ethtool running under pm-suspend seemed to be the
> problem:
> 
> root 11558 pts/8    S+ \_ /bin/sh /usr/lib/pm-utils/sleep.d/00powers
> root 11559 pts/8    S+     \_ /bin/sh /usr/sbin/pm-powersave
> root 11576 pts/8    S+         \_ /bin/sh /usr/lib/pm-utils/power.d/
> root 11577 pts/8    D+             \_ ethtool -s eth0 wol g
[...]

Wake-on-LAN configuration is entirely handled by the relevant driver;
the ethtool core just copies the parameters in and out.  It looks like
there is some sort of deadlock or missing unlock in the driver.  So my
question would be which driver is running eth0?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

