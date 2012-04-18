Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2DRPYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:24:04 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:32907 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2DRPYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:24:02 -0400
Date: Wed, 18 Apr 2012 08:23:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120418152301.GF6034@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1838583439.163624.1333635333132.JavaMail.www@wwinf1m19>
 <20120405143918.GE27672@linux.vnet.ibm.com>
 <588810225.17969.1333703883646.JavaMail.www@wwinf1g24>
 <20120410160706.GF2428@linux.vnet.ibm.com>
 <4F859E0E.8050408@wanadoo.fr>
 <20120412180432.GE2394@linux.vnet.ibm.com>
 <20120416210234.GA3490@linux.vnet.ibm.com>
 <4F8E8B58.1040203@wanadoo.fr>
 <20120418140108.GA6034@linux.vnet.ibm.com>
 <4F8ED6FE.1000104@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F8ED6FE.1000104@wanadoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041815-4242-0000-0000-000001626B9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 05:00:14PM +0200, Pascal Chapperon wrote:
> Le 18/04/2012 16:01, Paul E. McKenney a écrit :
> >On Wed, Apr 18, 2012 at 11:37:28AM +0200, Pascal Chapperon wrote:
> >>Mount and umount operations are not slower with RCU_FAST_NO_HZ during
> >>runtime; systemctl start and stop operations are also not slower. In
> >>fact, i couldn't find a single operation slower during runtime with
> >>RCU_FAST_NO_HZ.
> >
> >Your boot-time setup is such that all CPUs are online before the
> >boot-time mount operations take place, right?
> Yes :
> [    0.242697] Brought up 8 CPUs
> [    0.242699] Total of 8 processors activated (35118.33 BogoMIPS).
> 
> > Struggling to understand
> >how RCU can tell the difference between post-CPU-bringup boot time
> >and run time...
> >
> systemd is controlling the whole boot process including mount
> operation (apart root filesystem) and as I can see, uses heavily
> sockets to do it (not to mention cpu-affinity). It controls also the
> major part of umount operations. Is it possible that your patch hits
> a systemd bug ?

Is it possible that systemd is using network operations that include
synchronize_rcu()?  Then if you did the same operation from the
command line at runtime, you might not see the slowdown.

Is it possible for you to convince systemd to collect RCU event tracing
during the slow operation?  RCU event tracing is available under
/sys/kernel/debug/tracing/rcu.

> What I don't understand is that systemd coexists well with
> RCU_FAST_NO_HZ on a smaller laptop with older and much less powerful
> cpu.
> I'll do further tests on another machine.

There might well be a timing-related problem.

							Thanx, Paul

