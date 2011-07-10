Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1GJApj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 20:45:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46829 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab1GJApg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 20:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110709100900.GB6014@linux.vnet.ibm.com>
References: <CAAVPGONLqy+gn_ggjQxyUoYifs4Hipcd-0t931w04StyrTCzxQ@mail.gmail.com>
	<201107072047.14429.kernelmail.jms@gmail.com>
	<20110707195845.GD6014@linux.vnet.ibm.com>
	<201107072147.12751.kernelmail.jms@gmail.com>
	<20110708002903.GI6014@linux.vnet.ibm.com>
	<20110709100900.GB6014@linux.vnet.ibm.com>
Date: Sun, 10 Jul 2011 01:45:35 +0100
Message-ID: <CAAVPGOMe6NawfkNQ1pSGYe5a1=X0z_KcD5Dn_xDX55p3K_46nQ@mail.gmail.com>
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
From: julie Sullivan <kernelmail.jms@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Very good.  I have created a new jms.2011.07.07a branch in the -rcu
>git tree at:

I get my own branch! :-) (thanks for all your trouble with this.)

>Hello, Julie,

>Any news?

Sorry for the delay (again), I have to work very late Fridays and Saturdays.
Anyway, I have tested the six commits on my v3.0-rc4 branch (with
f8b7fc6b514f34a5 and a46e0899eec7a3069bc reverted) and can confirm
that they _all_ produce a bootable kernel at my end.

Btw, you may have noticed that my config has RCU_BOOST=n?
If I build a simple v3.0-rc4 kernel (ie one which includes the four
original commits (f8b7fc6b514, a46e0899eec, 09223371dea and
9a432736904)) but with RCU_BOOST=y it _will_ boot. I didn't know if
this was helpful or not.

If it is helpful, you probably know this, but in order to get
RCU_BOOST=y I have to change a couple of other configs - PREEMPT_RCU=y
(previously n) and to get PREEMPT_RCU=y, my preemption model has to be
'Preemptible Kernel (Low-Latency Desktop)' - PREEMPT=y (instead of
'Voluntary Kernel Preemption (Desktop)' - PREEMPT=n which it was
originally).

It's my day off tomorrow so I'll do some more testing (on -rc5 and
-rc6) (past 1.30am here in the UK now).

HTH,
Julie
