Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab2KQOyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 09:54:44 -0500
Received: from mx.treblig.org ([80.68.94.177]:39581 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2KQOyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 09:54:43 -0500
X-Greylist: delayed 1871 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Nov 2012 09:54:43 EST
Date: Sat, 17 Nov 2012 14:23:31 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>, nik@linuxbox.cz
Subject: Re: strange values of loadavg and nr of io-blocked tasks
Message-ID: <20121117142331.GA2868@gallifrey>
References: <20121116114703.GA8634@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116114703.GA8634@pcnci.linuxbox.cz>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.36.4-kvm-i386-20110819 (i686)
X-Uptime: 14:12:58 up 257 days, 46 min,  2 users,  load average: 0.00,
 0.01, 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nikola Ciprich (nikola.ciprich@linuxbox.cz) wrote:
> Hi,
> 
> I was doing some I/O tuning of our KVM host, and noticed some
> strange behaviour. When I start some heavy I/O load on guest
> (ie run some fio benchmark), loadavg value of the host jumps
> to value about 65 and holds until load ends. sar reports similar
> number of blocked tasks. I don't really understand those numbers,
> because only active tasks are 4 qemu-kvm threads and few other sleeping
> tasks (so none in R or D state).
> is it possible to somehow find which tasks seem to be blocked?
> or why is loadavg value so high?
> the system is x86_64 quad core with 4GB RAM running centos 6 with 3.0.52-rc1 kernel.

Recebt qemu split there io across multiple threads (as an alternative to AIO),
so what you"ll see is each qemu will dynamically start a load of threads when
is doing heavy IO, none of them will usr much cpu, but each will be blocking on io, and hence count as a 1 for the load.

It does have some flags (which I forget) that let you limit the number of
threads or flip to AIO.

Other than getting a scary loadavg number, it doesn't seem to have any bad
effecta.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
