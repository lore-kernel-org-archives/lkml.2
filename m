Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab2LULG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:06:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55429 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LULGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:06:20 -0500
Message-ID: <1356087972.4547.26.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.6.6-rt17
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 21 Dec 2012 12:06:12 +0100
In-Reply-To: <alpine.LFD.2.02.1211122223300.10000@ionos>
References: <alpine.LFD.2.02.1211122223300.10000@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:boQQmhI3xGiVTu+aoVR+tWR/q/76UzV51NjtKCWOYsU
 YUmxcj76MRxguRonpQL2MkJ0fiWkX89h9ogrlhM7rGvxqrd7dO
 QnShh/gI+aKExgxTIDgRtQg5vYMyHFLVhi9/2sT2oW2/Q4FCN0
 aXZVkHt62qFwGZVzHn47+7pl/jePvdSKaH34x5gfltjUT0K6hZ
 Apk2YgH/asmIBQ78ptEDcySlvlN6l3m/Ty24BtIjHIkv9Mprus
 xjRRIMtuhp7RAX/ETWH/YQWPkysSY2stw/CTKuLeRh3IYQdPFl
 BVqNZgcnl3WlVlffdIFt1eKM+r1C8FWv8suT14Yij5QZVEglTT
 Q2OOvVp05mvz/fAetLzfN9ae3mKnlOymzTj7pdXFQaa5/I6Vs3
 4Ufje1QDjBXOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 22:28 +0100, Thomas Gleixner wrote: 
> Dear RT Folks,
> 
> I'm pleased to announce the 3.6.6-rt17 release. 3.6.6-rt16 is just a
> not announced update release to 3.6.6.
> 
> Changes since 3.6.6-rt16:
> 
>    * Finally make the NOHZ softirq pending detection work with the new
>      softirq scheme.

Well, almost.  They gripe when rebooting, but I haven't seen one other
than that.  This is 3.6.11-rt23 on a 64 core DL980 I set up to run some
latency tests on.

[  318.692463] kvm: exiting hardware virtualization
[  319.568482] Disabling non-boot CPUs ...
[  319.647819] NOHZ: local_softirq_pending 80
[  319.876148] NOHZ: local_softirq_pending 202
[  319.876172] NOHZ: local_softirq_pending 202
[  319.988912] NOHZ: local_softirq_pending 282
[  320.097066] NOHZ: local_softirq_pending 202
[  320.321428] NOHZ: local_softirq_pending 80
[  320.662601] NOHZ: local_softirq_pending 202
[  320.662637] NOHZ: local_softirq_pending 202
[  323.162636] NOHZ: local_softirq_pending 202
[  323.162649] NOHZ: local_softirq_pending 202
[  325.217675] Restarting system.

Don't suppose you know why LAZY_PREEMPT would make 3.0-rt explode if you
turn on wakeup_rt tracer do you?

I backported that and your softirq changes to 3.0.  New softirq handling
scheme work spiffy there, LAZY_PREEMPT works fine too.. until you turn
tracing on, then it corrupts memory, and makes mushroom cloud.

-Mike




