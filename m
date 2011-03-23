Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1CWAAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 20:00:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52025 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755419Ab1CWAAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 20:00:49 -0400
Date: Wed, 23 Mar 2011 00:01:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Collins <collinsd@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Deadlock scenario in regulator core
Message-ID: <20110323000100.GB2529@opensource.wolfsonmicro.com>
References: <4D891C59.1030009@codeaurora.org>
 <20110322223702.GO14675@home.goodmis.org>
 <4D892C0A.1090606@codeaurora.org>
 <1300835998.14261.13.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300835998.14261.13.camel@gandalf.stny.rr.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 07:19:58PM -0400, Steven Rostedt wrote:

> Looks to me that the mutex_lock() in _notifier_call_chain needs to be a
> mutex_lock_nested().

> The "_nested()" versions are when you have the same type of mutex taken
> but belonging to two different instances. Like you have here:

What's a mutex type?  I have to say this is the first time I've heard of
mutex types and the documentation in mutex.c and mutex-design.txt isn't
precisely verbose on what mutex_lock_nested() is for or how one would
pick subclass.
