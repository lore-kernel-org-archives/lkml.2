Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2D0MP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:15:26 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:55696 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab2D0MPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:15:25 -0400
Date: Fri, 27 Apr 2012 14:15:20 +0200 (CEST)
From: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Reply-To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Message-ID: <20177034.34764.1335528920975.JavaMail.www@wwinf1f04>
Subject: Re: RCU related performance regression in 3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [84.101.239.180]
X-WUM-FROM: |~|
X-WUM-TO: |~|
X-WUM-CC: |~||~||~|
X-WUM-REPLYTO: |~|
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/04/2012 17:23, Paul E. McKenney a écrit :
> On Wed, Apr 18, 2012 at 05:00:14PM +0200, Pascal Chapperon wrote:
>> Le 18/04/2012 16:01, Paul E. McKenney a écrit :
>>> On Wed, Apr 18, 2012 at 11:37:28AM +0200, Pascal Chapperon wrote:
>>>> Mount and umount operations are not slower with RCU_FAST_NO_HZ during
>>>> runtime; systemctl start and stop operations are also not slower. In
>>>> fact, i couldn't find a single operation slower during runtime with
>>>> RCU_FAST_NO_HZ.
>>>
>>> Your boot-time setup is such that all CPUs are online before the
>>> boot-time mount operations take place, right?
>> Yes :
>> [ 0.242697] Brought up 8 CPUs
>> [ 0.242699] Total of 8 processors activated (35118.33 BogoMIPS).
>>
>>> Struggling to understand
>>> how RCU can tell the difference between post-CPU-bringup boot time
>>> and run time...
>>>
>> systemd is controlling the whole boot process including mount
>> operation (apart root filesystem) and as I can see, uses heavily
>> sockets to do it (not to mention cpu-affinity). It controls also the
>> major part of umount operations. Is it possible that your patch hits
>> a systemd bug ?
> 
> Is it possible that systemd is using network operations that include
> synchronize_rcu()? Then if you did the same operation from the
> command line at runtime, you might not see the slowdown.
> 
> Is it possible for you to convince systemd to collect RCU event tracing
> during the slow operation? RCU event tracing is available under
> /sys/kernel/debug/tracing/rcu.
>
.
I have collected the RCU event tracing during a slow boot with
FAST_NO_HZ (and the same without FAST_NO_HZ, same kernel config).
The full logs and associated "systemd-analyze plot" can be found
(in comment 32) at :

https://bugzilla.redhat.com/show_bug.cgi?id=806548

With FAST_NO_HZ, almost each rcu_prep_idle is followed by ksoftirqd
(75000 ksoftirqd lines with FAST_NO_HZ, 4000 without).

Sorry, the logs are very huge, but I can't figure where are the 
plots of some interest. 

Pascal
