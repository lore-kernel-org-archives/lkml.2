Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1CGWvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 17:51:16 -0500
Received: from flusers.ccur.com ([173.221.59.2]:43176 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755527Ab1CGWvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 17:51:15 -0500
Date: Mon, 7 Mar 2011 17:51:10 -0500
From: Joe Korty <joe.korty@ccur.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] An RCU for SMP with a single CPU garbage collector
Message-ID: <20110307225110.GA19414@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110307210157.GG3104@linux.vnet.ibm.com>
 <20110307211613.GA26455@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307211613.GA26455@tsunami.ccur.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 04:16:13PM -0500, Joe Korty wrote:
> On Mon, Mar 07, 2011 at 04:01:57PM -0500, Paul E. McKenney wrote:
>> But I would really prefer leveraging the existing RCU implementations
>> to the extent possible.  Are the user-dedicated CPUs able to invoke
>> system calls?  If so, something like Frederic's approach should permit
>> the existing RCU implementations to operate normally.  If not, what is
>> doing the RCU read-side critical sections on the dedicated CPUs?
> 
> I thought about the system call approach but rejected it.
> Some (maybe many) customers needing dedicated CPUs will
> have apps that never make any system calls at all.

Hi Paul,
Thinking about it some more, the tap-into-syscall approach might
work in my implementation, in which case the tap-into-preempt-enable
code could go away.

Nice thing about RCU, the algorithms are infinitely mallable :)

Joe
