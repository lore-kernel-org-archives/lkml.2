Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab2D1DnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 23:43:17 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59887 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2D1DnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 23:43:15 -0400
Date: Fri, 27 Apr 2012 20:42:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120428034257.GA2495@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20177034.34764.1335528920975.JavaMail.www@wwinf1f04>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20177034.34764.1335528920975.JavaMail.www@wwinf1f04>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042803-6148-0000-0000-000005638ECB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 02:15:20PM +0200, Pascal Chapperon wrote:
> Le 18/04/2012 17:23, Paul E. McKenney a écrit :
> > On Wed, Apr 18, 2012 at 05:00:14PM +0200, Pascal Chapperon wrote:
> >> Le 18/04/2012 16:01, Paul E. McKenney a écrit :
> >>> On Wed, Apr 18, 2012 at 11:37:28AM +0200, Pascal Chapperon wrote:
> >>>> Mount and umount operations are not slower with RCU_FAST_NO_HZ during
> >>>> runtime; systemctl start and stop operations are also not slower. In
> >>>> fact, i couldn't find a single operation slower during runtime with
> >>>> RCU_FAST_NO_HZ.
> >>>
> >>> Your boot-time setup is such that all CPUs are online before the
> >>> boot-time mount operations take place, right?
> >> Yes :
> >> [ 0.242697] Brought up 8 CPUs
> >> [ 0.242699] Total of 8 processors activated (35118.33 BogoMIPS).
> >>
> >>> Struggling to understand
> >>> how RCU can tell the difference between post-CPU-bringup boot time
> >>> and run time...
> >>>
> >> systemd is controlling the whole boot process including mount
> >> operation (apart root filesystem) and as I can see, uses heavily
> >> sockets to do it (not to mention cpu-affinity). It controls also the
> >> major part of umount operations. Is it possible that your patch hits
> >> a systemd bug ?
> > 
> > Is it possible that systemd is using network operations that include
> > synchronize_rcu()? Then if you did the same operation from the
> > command line at runtime, you might not see the slowdown.
> > 
> > Is it possible for you to convince systemd to collect RCU event tracing
> > during the slow operation? RCU event tracing is available under
> > /sys/kernel/debug/tracing/rcu.
> >
> .
> I have collected the RCU event tracing during a slow boot with
> FAST_NO_HZ (and the same without FAST_NO_HZ, same kernel config).
> The full logs and associated "systemd-analyze plot" can be found
> (in comment 32) at :
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=806548
> 
> With FAST_NO_HZ, almost each rcu_prep_idle is followed by ksoftirqd
> (75000 ksoftirqd lines with FAST_NO_HZ, 4000 without).
> 
> Sorry, the logs are very huge, but I can't figure where are the 
> plots of some interest. 

Thank you for collecting them!  I clearly will need to do some scripting.  ;-)

							Thanx, Paul

