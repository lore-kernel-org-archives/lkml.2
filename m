Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab0LUB1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:27:50 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:46053 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab0LUB1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:27:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=beMWFjSCoJ+vuQvzCovCiLZ+uJY5kz4Rr6MTyjKW1tdFyUKErZ0QE/TP0LBK+lIBwJ
         CugChr2dLYfXjA86KK51j60oqBdiMaHX/bfAtsqSPvwChNBnx2kFFyANvaGG5D+XB6TB
         OB36s0JCs/T/e7NZy1LOuEOtQiT90FWosUF/w=
Date: Tue, 21 Dec 2010 02:27:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 10/15] nohz_task: Enter in extended quiescent state
 when in userspace
Message-ID: <20101221012742.GJ1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-11-git-send-email-fweisbec@gmail.com>
 <1292861920.5021.29.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292861920.5021.29.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:18:40PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > (we check if the local cpu is in nohz mode, which means
> > no other task compete on that CPU)
> 
> You keep repeating that definition, but its not true.. It means there is
> not work for the tick to do, the tick does _tons_ more besides
> preemption, so nr_running==1 is necessary but not sufficient. 

Sure but the point is that if the tick is not running, it means
that the nohz task is the only task running on that CPU.

Now indeed there are other reasons for the tick to restart like RCU
or the effective nohz mode to physically happen or to be delayed,
which is decided by tick_nohz_stop_sched_tick().
