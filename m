Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1F1G1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:27:34 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:58995 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab1F1GZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:25:51 -0400
Date: Tue, 28 Jun 2011 09:19:27 +0300
From: Apollon Oikonomopoulos <apoikos@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: john stultz <johnstul@us.ibm.com>, Faidon Liambotis <paravoid@debian.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?utf-8?B?SGVydsOp?= Commowick <hcommowick@exosec.fr>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110628061927.GA9045@crowley.csl.mech.ntua.gr>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
 <20110428183434.GG30645@1wt.eu>
 <20110429100200.GB23293@pcnci.linuxbox.cz>
 <20110430093605.GA10529@1wt.eu>
 <20110430173905.GA25641@tty.gr>
 <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
 <20110628051732.GB15699@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Disposition: inline
In-Reply-To: <20110628051732.GB15699@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (diomedes.noc.ntua.gr [IPv6:2001:648:2000:de::220]); Tue, 28 Jun 2011 09:19:36 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:17 Tue 28 Jun     , Willy Tarreau wrote:
> On Mon, Jun 27, 2011 at 07:25:31PM -0700, john stultz wrote:
> > That said, I didn't see from any of the backtraces in this thread why
> > the system actually crashed.  The softlockup message on its own
> > shouldn't do that, so I suspect there's still a related issue
> > somewhere else here.
> 
> One of the traces clearly showed that the kernel's uptime had wrapped
> or jumped, because the uptime suddenly jumped forwards to something
> like 2^32/HZ seconds IIRC.
> 
> Thus it is possible that we have two bugs, one on the clock making it
> jump forwards and one somewhere else causing an overflow when the clock
> jumps too far.

Our last machine with wrapped time crashed 1 month ago, almost 1 month after
the time wrap. One thing I noticed, was that although the machine seemed
healthy apart from the time-wrap, there seemed to be random scheduling
glitches, which were mostly visible as high ping times to the KVM guests
running on the machine. Unfortunately I don't have any exact numbers, so I
suppose the best I can do is describe what we saw.

All scheduler statistics under /proc/sched_debug on the host seemed normal,
however pinging a VM from outside would give random spikes in the order of
hundreds of ms among the usual 1-2 ms times. Moving the VM to another host
would restore sane ping times and any other VM moved to this host would exhibit
the same behaviour. Ping times to the host itself from outside were stable.
This was also accompanied by bad I/O performance in the KVM guests themelves
and the strange effect that the total CPU time on the VM's munin graphs would
add to less than 100% * #CPUs.  Neither the host nor the guests were
experiencing heavy load.

As a side note, this was similar to the behaviour we had experienced once when
some of multipathd's path checkers (which are RT tasks IIRC) had crashed,
although this time restarting multipathd didn't help.

Regards,
Apollon
