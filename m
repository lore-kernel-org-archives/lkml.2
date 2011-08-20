Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab1HTHqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 03:46:14 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:33484 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1HTHqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 03:46:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110818132531.GA10441@somewhere>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <4E4BEE1F.9060500@redhat.com> <20110818132531.GA10441@somewhere>
From: Paul Menage <paul@paulmenage.org>
Date: Sat, 20 Aug 2011 00:45:48 -0700
X-Google-Sender-Auth: cMGWXmHTLlwypPvbM_n6SPPqOFY
Message-ID: <CALdu-PAd_sr=k1xDPgeFr4Cx2U2x+EZYUz4ykyrNUSCSOb2osQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 6:25 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>
>> Why not do it unconditionally?  That is, if all the conditions are
>> fulfilled, disable the tick regardless of any cpuset settings.
>
> Because I'm not sure it's a win on every workload. This involves
> some hooks here and there (syscall slow path), IPIs, etc...

I agree with Avi. I'd be inclined to investigate further to see if
there are any important workloads on which it's not a win - and then
add the extra complexity to control it from cpusets if necessary.
Unless there's really a good reason to make it configurable, it's
simpler to make it unconditional.

Paul
