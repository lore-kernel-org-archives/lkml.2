Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab1EMNNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:13:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:59036 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758584Ab1EMNNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:13:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Oo1tVtyLOB1v2+TT0A3TeAwpnnPkG9EyRRe67fI
	8Fx0aDEqKMuMTi
Subject: Re: Sched_autogroup and niced processes
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Carl-Johan Kjellander <carl-johan@klarna.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110513100411.GA21022@elte.hu>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
	 <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
	 <1305273950.15080.7.camel@marge.simson.net>
	 <20110513082250.GB13647@elte.hu> <1305276066.2561.1.camel@twins>
	 <20110513090537.GH13647@elte.hu> <1305277666.2561.9.camel@twins>
	 <20110513092933.GL13647@elte.hu> <1305279990.2466.4.camel@twins>
	 <20110513100411.GA21022@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 15:13:26 +0200
Message-ID: <1305292406.27263.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 12:04 +0200, Ingo Molnar wrote:

> Still, the other important problem is that we still seem to have a bug, even 
> with the cgroup set to low prio seti@home is sucking up CPU resources ...

I don't see how.  Other than the expected nice 19 overrun when nice 0
group blocks, it works fine on my little Q6600 box.

time make -j4 vmlinux (cache hot)

real    2m22.996s  
user    7m6.887s
sys     0m48.999s

echo 0 > sched_autogroup_enabled

time make -j4 vmlinux

real    2m17.052s        (darn, no free lunch)
user    7m5.483s
sys     0m49.415s

echo 1 > sched_autogroup_enabled

simultaneous massive_intr 8 9999 in nice 19 autogroup and
time make -j4 vmlinux in a nice 0 autogroup

real    2m30.863s
user    7m5.363s
sys     0m47.359s

142.996/150.863 = .947  (a tad low)

repeat with 2 kbuild tasks/core to cut nice 0 group's idle time

time make -j8 vmlinux

real    2m24.925s
user    7m16.327s
sys     0m50.807s

142.996/144.925 = .986  (all better)

	-Mike

