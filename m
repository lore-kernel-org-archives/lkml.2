Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2EEGIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 02:08:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55885 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752302Ab2EEGIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 02:08:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19YDDdQDpBYFNTu0A1pAIl54KVMYA7jdzPmM7BGxa
	medjOd8P0wgXo2
Message-ID: <1336198093.7346.11.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Sat, 05 May 2012 08:08:13 +0200
In-Reply-To: <1336197362.7346.9.camel@marge.simpson.net>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com>
	 <1335754867.17899.4.camel@marge.simpson.net>
	 <m1zk9rmyh4.fsf@fess.ebiederm.org>
	 <20120501134214.f6b44f4a.akpm@linux-foundation.org>
	 <1336014721.7370.32.camel@marge.simpson.net>
	 <1336057018.8119.46.camel@marge.simpson.net>
	 <1336105676.7356.42.camel@marge.simpson.net>
	 <m1aa1oidmn.fsf@fess.ebiederm.org>
	 <1336124716.25479.36.camel@marge.simpson.net>
	 <m1vckcdoey.fsf@fess.ebiederm.org>
	 <1336142995.25479.49.camel@marge.simpson.net>
	 <m1zk9oc61j.fsf@fess.ebiederm.org>
	 <1336150643.7502.4.camel@marge.simpson.net>
	 <m1fwbfd71h.fsf@fess.ebiederm.org>
	 <1336197362.7346.9.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-05 at 07:56 +0200, Mike Galbraith wrote: 
> On Fri, 2012-05-04 at 13:29 -0700, Eric W. Biederman wrote:
> 
> > Shrug.  I have skimmed through all of that code and I don't see anything
> > obvious.  I guess it would take a few more data points to figure out
> > where we are sleeping for a jiffy or two while we are reaping children.

egrep 'synchronize|rcu_barrier' /trace 

          vsftpd-7981  [003] ....   577.164997: synchronize_sched <-switch_task_namespaces
          vsftpd-7981  [003] ....   577.164998: _cond_resched <-synchronize_sched
          vsftpd-7981  [003] ....   577.164998: wait_rcu_gp <-synchronize_sched
          vsftpd-7982  [003] ....   577.166583: synchronize_sched <-switch_task_namespaces
          vsftpd-7982  [003] ....   577.166583: _cond_resched <-synchronize_sched
          vsftpd-7982  [003] ....   577.166584: wait_rcu_gp <-synchronize_sched
          vsftpd-7983  [003] ....   577.167128: synchronize_sched <-switch_task_namespaces
          vsftpd-7983  [003] ....   577.167129: _cond_resched <-synchronize_sched
          vsftpd-7983  [003] ....   577.167129: wait_rcu_gp <-synchronize_sched
          vsftpd-7980  [003] ....   577.167678: synchronize_sched <-switch_task_namespaces
          vsftpd-7980  [003] ....   577.167679: _cond_resched <-synchronize_sched
          vsftpd-7980  [003] ....   577.167679: wait_rcu_gp <-synchronize_sched
          vsftpd-7984  [003] ....   577.168232: synchronize_sched <-switch_task_namespaces
          vsftpd-7984  [003] ....   577.168232: _cond_resched <-synchronize_sched
          vsftpd-7984  [003] ....   577.168233: wait_rcu_gp <-synchronize_sched
          vsftpd-7979  [003] ....   577.168800: synchronize_sched <-switch_task_namespaces
          vsftpd-7979  [003] ....   577.168800: _cond_resched <-synchronize_sched
          vsftpd-7979  [003] ....   577.168801: wait_rcu_gp <-synchronize_sched
          vsftpd-7985  [003] ....   577.169373: synchronize_sched <-switch_task_namespaces
          vsftpd-7985  [003] ....   577.169373: _cond_resched <-synchronize_sched
          vsftpd-7985  [003] ....   577.169373: wait_rcu_gp <-synchronize_sched
          vsftpd-7986  [003] ....   577.169946: synchronize_sched <-switch_task_namespaces
          vsftpd-7986  [003] ....   577.169947: _cond_resched <-synchronize_sched
          vsftpd-7986  [003] ....   577.169947: wait_rcu_gp <-synchronize_sched
          vsftpd-7987  [003] ....   577.170519: synchronize_sched <-switch_task_namespaces
          vsftpd-7987  [003] ....   577.170519: _cond_resched <-synchronize_sched
          vsftpd-7987  [003] ....   577.170519: wait_rcu_gp <-synchronize_sched
          vsftpd-7978  [003] ....   577.171091: synchronize_sched <-switch_task_namespaces
          vsftpd-7978  [003] ....   577.171091: _cond_resched <-synchronize_sched
          vsftpd-7978  [003] ....   577.171091: wait_rcu_gp <-synchronize_sched
          vsftpd-7977  [003] ....   577.171519: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.171519: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.171519: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.171519: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.171520: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.171520: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] d...   577.171532: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.171532: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] ....   577.171533: wait_for_completion <-_rcu_barrier.isra.31
     ksoftirqd/3-16    [003] ..s.   577.171691: rcu_barrier_callback <-__rcu_process_callbacks
          vsftpd-7977  [003] ....   577.176443: mutex_unlock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.176552: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.176552: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.176553: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.176553: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.176553: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.176554: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] d...   577.176561: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.176561: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] ....   577.176562: wait_for_completion <-_rcu_barrier.isra.31
     ksoftirqd/3-16    [003] ..s.   577.176730: rcu_barrier_callback <-__rcu_process_callbacks
          vsftpd-7977  [003] ....   577.180448: mutex_unlock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.180553: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.180553: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.180554: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.180554: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.180555: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.180555: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] d...   577.180561: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.180562: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] ....   577.180563: wait_for_completion <-_rcu_barrier.isra.31
     ksoftirqd/3-16    [003] ..s.   577.180767: rcu_barrier_callback <-__rcu_process_callbacks
          vsftpd-7977  [003] ....   577.184450: mutex_unlock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.184565: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.184566: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.184566: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.184566: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.184566: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.184567: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] d...   577.184573: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.184573: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] ....   577.184573: wait_for_completion <-_rcu_barrier.isra.31
     ksoftirqd/3-16    [003] ..s.   577.184733: rcu_barrier_callback <-__rcu_process_callbacks
          vsftpd-7977  [003] ....   577.188430: mutex_unlock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.188536: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.188536: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.188536: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.188536: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.188537: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.188537: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] d...   577.188555: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.188555: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] ....   577.188555: wait_for_completion <-_rcu_barrier.isra.31
     ksoftirqd/3-16    [003] ..s.   577.188715: rcu_barrier_callback <-__rcu_process_callbacks
          vsftpd-7977  [003] ....   577.192421: mutex_unlock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.192527: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.192527: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.192527: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.192527: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.192528: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.192528: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] d...   577.192546: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.192546: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] ....   577.192547: wait_for_completion <-_rcu_barrier.isra.31
     ksoftirqd/3-16    [003] ..s.   577.192731: rcu_barrier_callback <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.192731: complete <-rcu_barrier_callback
          vsftpd-7977  [003] ....   577.192750: mutex_unlock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.192821: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.192821: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.192821: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.192821: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.192822: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.192822: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] d...   577.192832: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.192833: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] ....   577.192833: wait_for_completion <-_rcu_barrier.isra.31
     ksoftirqd/3-16    [003] ..s.   577.196559: rcu_barrier_callback <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196560: complete <-rcu_barrier_callback
          vsftpd-7977  [003] ....   577.196571: mutex_unlock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.196642: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.196642: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.196642: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.196642: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.196643: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.196643: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] d...   577.196653: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.196654: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] ....   577.196654: wait_for_completion <-_rcu_barrier.isra.31
     ksoftirqd/3-16    [003] ..s.   577.200577: rcu_barrier_callback <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.200577: complete <-rcu_barrier_callback
          vsftpd-7977  [003] ....   577.200589: mutex_unlock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.200659: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.200659: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.200659: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.200659: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.200660: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.200660: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] d...   577.200671: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.200671: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] ....   577.200672: wait_for_completion <-_rcu_barrier.isra.31
     ksoftirqd/3-16    [003] ..s.   577.204548: rcu_barrier_callback <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.204548: complete <-rcu_barrier_callback
          vsftpd-7977  [003] ....   577.204559: mutex_unlock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.204630: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.204631: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.204631: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.204631: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.204631: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.204631: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] d...   577.204642: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.204642: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] ....   577.204643: wait_for_completion <-_rcu_barrier.isra.31
     ksoftirqd/3-16    [003] ..s.   577.208511: rcu_barrier_callback <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.208511: complete <-rcu_barrier_callback
          vsftpd-7977  [003] ....   577.208523: mutex_unlock <-_rcu_barrier.isra.31


