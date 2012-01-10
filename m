Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2AJIIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:08:09 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:39282 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2AJIII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:08:08 -0500
MIME-Version: 1.0
In-Reply-To: <1326160461.2366.19.camel@sbsiddha-mobl2>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	<1326103578.2442.50.camel@twins>
	<20120110001445.GA20542@linux-youquan.bj.intel.com>
	<1326107563.2442.65.camel@twins>
	<CAKfTPtDM-L-AcHr_o44vmR9VYRvQqOyXuwEgnZ61d4pbDOPFUg@mail.gmail.com>
	<1326160461.2366.19.camel@sbsiddha-mobl2>
Date: Tue, 10 Jan 2012 09:08:06 +0100
Message-ID: <CAKfTPtA_ORWsgLOZ2+Nn8RdAXQ_4Nu16RCk9J3f04+YyjYuemA@mail.gmail.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        arjan@linux.intel.com, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 January 2012 02:54, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> On Mon, 2012-01-09 at 15:29 +0100, Vincent Guittot wrote:
>> Hi Peter,
>>
>> I'm also using sched_mc level for doing powersaving load balance on
>> ARM platform and we have real benefits.
>
> hi Vincent, Can you elaborate on your platform topology where you see
> the benefits?
>

Hi Suresh,

I'm using dual/quad cores ARM platform. When sched_mc is different
from 0, the topology is changed from 1 socket/cluster to 2 virtual
sockets/clusters with 1 or 2 cores in each cluster.  For low cpu load
situation, the tasks are gathered in 1 virtual socket and let the
cores in the other socket to enter idle state thanks to cpuidle. On
ARM platform, cores in a cluster can enter interesting idle state even
if the complete cluster can't reach a deep idle state.
With dual cores platform, i'm increasing the cpu_power to gather tasks
on 1 core when cores are at lowest frequency. In fact i'm detecting a
low cpu load (only small tasks are running) and ensure that these
small tasks are kept on 1 core.

Regards,
Vincent

> on x86, 'sched_mc' was designed for the case of consolidating load into
> one socket before using another idle socket.
>
> Just wondering if this is your use case too or if you are consolidating
> at a different topological level.
>
> thanks,
> suresh
>
