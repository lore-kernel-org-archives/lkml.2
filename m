Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1KWQMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:12:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61419 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1KWQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:12:09 -0500
Date: Wed, 23 Nov 2011 08:12:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] trace_events_filter: use rcu_assign_pointer() when
 setting ftrace_event_call->filter
Message-ID: <20111123161203.GC25780@google.com>
References: <20111123014603.GA19630@google.com>
 <1322061407.20742.51.camel@frodo>
 <20111123160653.GB25780@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123160653.GB25780@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 08:06:53AM -0800, Tejun Heo wrote:
> otherwise, it may fetch the old values from before the new area is
> initialized on archs where data dependency barrier isn't noop.

I think this can be a problem on archs where dd barrier is noop but
wmb is not.  dd barrier is implied on every read access but nothing
guarantees the updating CPU sends out write for the pointer assignment
before initialization of the new area.

Thanks.

-- 
tejun
