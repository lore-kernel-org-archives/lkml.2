Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2CFRlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:41:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41296 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755640Ab2CFRlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:41:08 -0500
Message-ID: <1331055666.2140.3.camel@joe2Laptop>
Subject: Re: [RFC PATCH] checkpatch: Warn on use of yield()
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Miao Xie <miaox@cn.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Tue, 06 Mar 2012 09:41:06 -0800
In-Reply-To: <1331037942.11248.307.camel@twins>
References: <20120302112358.GA3481@suse.de>
	 <1330723262.11248.233.camel@twins>
	 <20120305121804.3b4daed4.akpm@linux-foundation.org>
	 <1330999280.10358.3.camel@joe2Laptop> <1331037942.11248.307.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 13:45 +0100, Peter Zijlstra wrote:
> The case at hand was a life-lock due to expecting that yield() would run
> another process which it needed in order to complete. Yield() does not
> provide that guarantee.

OK.

Perhaps the kernel-doc comments in sched/core.c
should/could be expanded/updated.

/**
 * sys_sched_yield - yield the current processor to other threads.
 *
 * This function yields the current CPU to other tasks. If there are no
 * other threads running on this CPU then this function will return.
 */

[]

/**
 * yield - yield the current processor to other threads.
 *
 * This is a shortcut for kernel-space yielding - it marks the
 * thread runnable and calls sys_sched_yield().
 */
void __sched yield(void)
{
	set_current_state(TASK_RUNNING);
	sys_sched_yield();
}
EXPORT_SYMBOL(yield);


