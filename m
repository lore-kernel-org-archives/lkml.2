Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1IZAoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 20:44:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49558 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab1IZAoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 20:44:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Sep 2011 09:43:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Thelen <gthelen@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        PeterZijlstra <peterz@infradead.org>, ChristophLameter <cl@linux.com>
Subject: Re: [PATCH] memcg: Fix race condition in memcg_check_events() with
 this_cpu usage
Message-Id: <20110926094322.8ac019d5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1316825684.6387.5.camel@gandalf.stny.rr.com>
References: <1316825684.6387.5.camel@gandalf.stny.rr.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011 20:54:42 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> The code in memcg_check_events() calls this_cpu_read() on
> different variables without disabling preemption, and can cause
> the calculations to be done from two different CPU variables.
> 
> Disable preemption throughout the check to keep apples and oranges
> from becoming a mixed drink.
> 
> [ Added this_cpu to __this_cpu conversion by Johannes ]
> 
> Cc: Greg Thelen <gthelen@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Christoph Lameter <cl@linux.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Link: http://lkml.kernel.org/r/20110919212641.015320989@goodmis.org

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Andrew, could you pick this up ?

