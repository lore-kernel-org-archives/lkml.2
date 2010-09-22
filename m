Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab0IVPkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:40:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab0IVPkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:40:14 -0400
Date: Wed, 22 Sep 2010 11:40:10 -0400
From: Don Zickus <dzickus@redhat.com>
To: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.36-rc5 backtrace] NMI watchdog detects rcu_sched_state stall
Message-ID: <20100922154010.GJ26290@redhat.com>
References: <courier.4C98F124.00000CF9@fs.uni-ruse.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <courier.4C98F124.00000CF9@fs.uni-ruse.bg>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 08:53:40PM +0300, Plamen Petrov wrote:
> Hello!
> 
> Kernel 2.6.35-rc5 just wrote the following into system logs:
> 

<snipped backtrace>

> sched_clock_idle_sleep_event+0xe/0x10
> Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10297a9>]
> common_interrupt+0x29/0x30
> Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102f166>] ?
> mwait_idle+0x45/0x57
> Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1028353>] cpu_idle+0x3d/0x7a
> Sep 21 19:57:33 fs kernel: [11358.100853]  [<c13f88b8>] rest_init+0x58/0x5a
> Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa93a>]
> start_kernel+0x26a/0x270
> Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa4fb>] ?
> unknown_bootoption+0x0/0x19f
> Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa089>]
> i386_start_kernel+0x89/0x8b
> 
> This got caught with the help of NMI watchdog. I enabled NMI after
> the machine got
> so slow a couple of times I tought it hanged, but when I attached a
> monitor I saw
> this:
> 
> http://picpaste.com/536639578e2a95d666f695f4833453ed.jpg
> 
> Unfortunately, I was too busy at the time to post, and in need of a
> quick solution
> switched to an old stable kernel.
> 
> Should I open a bugreport with the details (hardware, kernel
> config)?

Hello Plamen,

Thanks for the report.  Unfortunately, you compiled with the old nmi
watchdog which is known to give false positives (because it has not been
updated to handle the new clock source).

If you have the time could you recompile with 
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y

This should utilize a new modern nmi watchdog detector and probably won't
output false positives like cpu 1 stuck in the idle loop.

Also perhaps next time could you attach the output of 'dmesg' instead of
/var/log/messages?  Your attachment is hard to read (it line wrapped on
me), making it difficult to see what is going on.

Cheers,
Don
