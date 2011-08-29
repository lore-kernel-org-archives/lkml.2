Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1H2OY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:24:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:50150 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1H2OX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:23:57 -0400
Subject: Re: [PATCH 02/32 RESEND] nohz: Drop ts->idle_active
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 16:23:12 +0200
In-Reply-To: <1313423549-27093-3-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314627792.2816.60.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:51 +0200, Frederic Weisbecker wrote:
> ts->idle_active is used to know if we want to account the idle sleep
> time. But ts->inidle is enough to check that.
> 
While possibly true, its not immediately obvious and no hints are
supplied. For example: tick_check_nohz() would disable ->idle_active..
where is this mirrored in the ->inidle state.

Also, tick_nohz_stop_sched_tick() has this comment:

	/*
	 * Set ts->inidle unconditionally. Even if the system did not
	 * switch to NOHZ mode the cpu frequency governers rely on the
	 * update of the idle time accounting in tick_nohz_start_idle().
	 */
	ts->inidle = 1;

Which suggest the ->inidle state doesn't accurately reflect things.

This is all rather hairy code, such changes really want more in terms of
explanation.


