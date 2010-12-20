Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab0LTXwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:52:11 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:44856 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab0LTXwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:52:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uHwLFN/fgCdFPjvDqdpT/TtYoHaV+tOTcYWSd1I7plCGRSIwcECTvTJI8rjFkjj0Pb
         FfYfkB07meXkKIUo4v9+QCWyZuZ3HWPPx27syCMbSnR9J1XOsxB9yc8ddexyE/ry7pgJ
         eTS+QVzAdnqk5GYR2CRykINk7Acghu/IYo6Zo=
Date: Tue, 21 Dec 2010 00:52:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 07/15] nohz_task: Restart tick when RCU forces nohz
 task cpu quiescent state
Message-ID: <20101220235158.GE1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-8-git-send-email-fweisbec@gmail.com>
 <1292860929.5021.16.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292860929.5021.16.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:02:09PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > If a cpu is in nohz mode due to a nohz task running, then
> > it is not able to notify quiescent states requested by other
> > CPUs.
> > 
> > Then restart the tick to remotely force the quiescent states on the
> > nohz task cpus.
> 
> -ENOPARSE.. if its in NOHZ state, it couldn't possibly need to
> participate in the quiescent state machine because the cpu is in a
> quiescent state and has 0 RCU activity.


But it can be in nohz state in the kernel in which case it can have
any RCU activity.
