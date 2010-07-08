Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab0GHR1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:27:45 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:53920 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758233Ab0GHR1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:27:43 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 13:27:43 EDT
Subject: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
       John Stultz <johnstul@us.ibm.com>,
       Fernando Pablo Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 10:19:50 -0700
Message-ID: <1278609590.7527.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are having problems with 2.6.33.5+rt23, at least in our configuration
while accessing an nfs automounted directory. This causes a complete
machine lockup (press reset to exit as the only option). 

I simply use the Nautilus file manager (in Fedora 12) to navigate to an
autofs mounted directory and the process monitor goes to 100% on one
core (or maybe two), the mouse jerks a bit and the whole thing goes
catatonic almost immediately. 

I get this in any open terminal at the time of the crash:

--------
Message from syslogd@localhost at Jul  8 10:13:54 ...
 kernel:------------[ cut here ]------------

Message from syslogd@localhost at Jul  8 10:13:54 ...
 kernel:invalid opcode: 0000 [#1] PREEMPT SMP 

Message from syslogd@localhost at Jul  8 10:13:54 ...
 kernel:last sysfs
file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

Message from syslogd@localhost at Jul  8 10:13:54 ...
 kernel:Process nautilus (pid: 2874, ti=f0204000 task=f17dd1f0
task.ti=f0204000)

Message from syslogd@localhost at Jul  8 10:13:54 ...
 kernel:Stack:

Message from syslogd@localhost at Jul  8 10:13:54 ...
 kernel:Call Trace:

Message from syslogd@localhost at Jul  8 10:13:54 ...
 kernel:Code: 7b 08 00 89 45 b8 75 12 8d 43 04 89 43 04 89 43 08 8d 43
0c 89 43 0c 89 43 10 8b 43 14 64 8b 15 2c d1 a5 c0 83 e0 fc 39 c2 75 04
<0f> 0b eb fe 8b 3a 81 ff 08 01 00 00 74 0a 83 ff 02 b8 04 00 00 

Message from syslogd@localhost at Jul  8 10:13:54 ...
 kernel:EIP: [<c0792c0f>] rt_spin_lock_slowlock+0x43/0x1bb SS:ESP
0068:f0205cbc
--------

And that's it... nothing else in the logs. 

For now we are booting into the normal Fedora kernel (this is on Fedora
12) as this makes the rt kernel not usable in our setup. 

Let me know if there is anything else I can do to help debug this...
-- Fernando


