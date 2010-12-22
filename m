Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0LVOG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:06:28 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54747 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0LVOG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:06:27 -0500
Subject: Re: [PATCH 5/5] Account ksoftirqd time as cpustat softirq -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>
In-Reply-To: <AANLkTimhtoMLSo1W421+EpXiSphcfJ_6z8=usrF4M3FH@mail.gmail.com>
References: <1292980144-28796-1-git-send-email-venki@google.com>
	 <1292980144-28796-6-git-send-email-venki@google.com>
	 <1293009621.2170.72.camel@laptop>
	 <AANLkTimhtoMLSo1W421+EpXiSphcfJ_6z8=usrF4M3FH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 15:05:24 +0100
Message-ID: <1293026724.2170.137.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 05:59 -0800, Venkatesh Pallipadi wrote:
> > So you add the ksoftirqd runtime as softirq time in the /proc/stat
> > output?
> >
> > That seems dubious...
> >
> 
> Yes. Thats similar to what we do today. As long as we are in softirq,
> whether bottomhalf or ksoftirqd, we account the tick as softirq time
> in /proc/stat.
> I thought it also makes sense from user perspective. They want to know
> how much time are we currently spending serving softirqs and hardirqs.
> It is better to get that information at one place, instead of say look
> at /proc/stat and add percpu ksoftirqd time to it. I mean,
> user/administrator does not have to care whether ksoftirqd is involved
> or not to know how much time was spend serving softirqs.
> 
But ksoftirqd time is also counted as sys time, so somewhere this won't
add up to 100%.
