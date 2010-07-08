Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab0GHXBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:01:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42494 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab0GHXBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:01:07 -0400
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: john stultz <johnstul@us.ibm.com>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278629044.12059.6.camel@localhost.localdomain>
References: <1278609590.7527.11.camel@localhost.localdomain>
	 <1278628386.3008.11.camel@localhost.localdomain>
	 <1278629044.12059.6.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 16:00:50 -0700
Message-ID: <1278630050.3008.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 15:44 -0700, Fernando Lopez-Lezcano wrote:
> On Thu, 2010-07-08 at 15:33 -0700, john stultz wrote:
> > On Thu, 2010-07-08 at 10:19 -0700, Fernando Lopez-Lezcano wrote:
> > > We are having problems with 2.6.33.5+rt23, at least in our configuration
> > > while accessing an nfs automounted directory. This causes a complete
> > > machine lockup (press reset to exit as the only option). 
> > > 
> > > I simply use the Nautilus file manager (in Fedora 12) to navigate to an
> > > autofs mounted directory and the process monitor goes to 100% on one
> > > core (or maybe two), the mouse jerks a bit and the whole thing goes
> > > catatonic almost immediately. 
> > > 
> > > I get this in any open terminal at the time of the crash:
> > > 
> > > --------
> > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > >  kernel:------------[ cut here ]------------
> > > 
> > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > >  kernel:invalid opcode: 0000 [#1] PREEMPT SMP 
> > > 
> > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > >  kernel:last sysfs
> > > file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> > > 
> > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > >  kernel:Process nautilus (pid: 2874, ti=f0204000 task=f17dd1f0
> > > task.ti=f0204000)
> > > 
> > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > >  kernel:Stack:
> > > 
> > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > >  kernel:Call Trace:
> > > 
> > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > >  kernel:Code: 7b 08 00 89 45 b8 75 12 8d 43 04 89 43 04 89 43 08 8d 43
> > > 0c 89 43 0c 89 43 10 8b 43 14 64 8b 15 2c d1 a5 c0 83 e0 fc 39 c2 75 04
> > > <0f> 0b eb fe 8b 3a 81 ff 08 01 00 00 74 0a 83 ff 02 b8 04 00 00 
> > > 
> > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > >  kernel:EIP: [<c0792c0f>] rt_spin_lock_slowlock+0x43/0x1bb SS:ESP
> > > 0068:f0205cbc
> > > --------
> > > 
> > > And that's it... nothing else in the logs. 
> > 
> > Hrm. Not too much to go on there, but thanks for the report.
> > 
> > 
> > > For now we are booting into the normal Fedora kernel (this is on Fedora
> > > 12) as this makes the rt kernel not usable in our setup. 
> > > 
> > > Let me know if there is anything else I can do to help debug this...
> > 
> > Had you done any testing with earlier 2.6.33-rt kernels where this
> > didn't occur? If so what version?
> 
> I have been working with the whole series but my main usage case does
> not use nfs/autofs (see next paragraphs). 
> 
> I have noticed that the problem does not appear to happen when I cd into
> an nfs automounted directory directly. It appears to happen only when
> listing the contents of a mount point (ie: when "/whatever/" is an
> autofs mount point where several directories are mounted, not
> necessarily from the same server). 
> 
> Before switching to Fedora 12 users were normally running 2.6.29 rt and
> I had been running 2.6.31.x and 2.6.33.x rt, but I don't think it ever
> happened to me personally (I'm always using the command line - this is
> completely reproducible with nautilus). After the switch it started
> happening almost immediately to regular users (using nautilus mostly). 
> 
> How could I try to get more debugging information?

Any chance you have a serial port on the machine in question? If so its
likely any oops messages could be collected over that.

If not, you can look at the netconsole documentation
(Documentation/networking/netconsole.txt) to try to configure that to
collect any panic info.

thanks
-john


 

