Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab1ITOVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:21:04 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54009 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab1ITOVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:21:02 -0400
Date: Tue, 20 Sep 2011 16:20:31 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Greg Thelen <gthelen@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 3/5] memcg: Disable preemption in
 memcg_check_events()
Message-ID: <20110920142031.GB17198@cmpxchg.org>
References: <20110919212040.745370781@goodmis.org>
 <20110919212641.015320989@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919212641.015320989@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 05:20:43PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The code in memcg_check_events() calls this_cpu_read() on
> different variables without disabling preemption, and can cause
> the calculations to be done from two different CPU variables.
> 
> Disable preemption throughout the check to keep apples and oranges
> from becoming a mixed drink.

Makes sense, thanks!

Since the atomic versions are no longer required with preemption
disabled explicitely, could you also make the this_cpu ops in
__memcg_event_check and __mem_cgroup_target_update non-atomic in the
same go?
