Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab1BRSir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:38:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:55196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1BRSip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:38:45 -0500
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and
 report
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <daahern@cisco.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <4D5EB564.6030504@cisco.com>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
	 <1298008433-22911-4-git-send-email-daahern@cisco.com>
	 <20110218070657.GA11404@elte.hu> <4D5E8204.2090501@cisco.com>
	 <20110218175926.GA3445@nowhere>  <4D5EB564.6030504@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 19:39:59 +0100
Message-ID: <1298054399.5226.779.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 11:07 -0700, David Ahern wrote:
> We want not only context-switch events, but the stack trace at the
> switch. 

Both ftrace and perf can do that:

 perf record -ge sched:sched_switch -c 1

or

echo 1 > /debug/tracing/options/stacktrace

> That data along with the gettimeofday timestamp has allowed us to
> resolve performance issues such as a system call taking longer than
> expected during a specific sequence of events or a process getting
> preempted and not scheduled for N seconds. etc., etc.

Non of that seems to require GTOD stamps.

