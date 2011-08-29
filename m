Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1H2Q7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:59:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35157 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab1H2Q66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:58:58 -0400
Date: Mon, 29 Aug 2011 18:58:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/32 RESEND] nohz: Drop useless ts->inidle check before
 rearming the tick
Message-ID: <20110829165850.GA9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-4-git-send-email-fweisbec@gmail.com>
 <1314627795.2816.61.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314627795.2816.61.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:23:15PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > We only need to check if we have ts->stopped to ensure the tick
> > was stopped and we want to re-enable it. Checking ts->inidle
> > there is useless. 
> 
> /me goes la-la-la-la... 
> 
> It would so help poor little me who hasn't stared at this code in detail
> for the past several days and is thus horridly confused if you'd expand
> your reasoning somewhat.

Sorry, I'm no big fan of writing changelogs and sometimes the lack
it's unfortunately visible :)$

It needs to be refactored due to the previous patch beeing broken.
But the rationale, indeed missing here, is that if you have ts->stopped
then you have ts->inidle. Once you entered tick_nohz_stop_sched_tick()
you have ts->inidle set and only once you reached that step the tick
can be stopped, so the following check:

	if (!ts->inidle || !ts->tick_stopped)

can be summed up with:

	if (!ts->tick_stopped) {

