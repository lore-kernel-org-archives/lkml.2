Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1H2OXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:23:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42567 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab1H2OXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:23:42 -0400
Subject: Re: [PATCH 01/32 RESEND] nohz: Drop useless call in
 tick_nohz_start_idle()
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
Date: Mon, 29 Aug 2011 16:23:10 +0200
In-Reply-To: <1313423549-27093-2-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314627790.2816.59.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:51 +0200, Frederic Weisbecker wrote:
> The call to update_ts_time_stats() there is useless. All
> we need is to save the idle entry_time.
> 
> 
Would have been clearer if you just said the call was a NOP. The whole
second sentence distracts and confuses as its irrelevant to the change
at hand.

If you want to expand you can explain that its a NOP because
update_ts_time_stats() requires either ts->idle_active and/or
@last_update_time and our callsite has neither.

Although this assumes its never called when ts->idle_active is already
set, is this so (likely)? Do we want a WARN_ON_ONCE() testing that
assumption?
