Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1KWQoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:44:38 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:38457 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1KWQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:44:37 -0500
Date: Wed, 23 Nov 2011 08:44:31 -0800
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace_events_filter: use rcu_assign_pointer() when
 setting ftrace_event_call->filter
Message-ID: <20111123164431.GG25780@google.com>
References: <20111123014603.GA19630@google.com>
 <1322066417.17693.56.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322066417.17693.56.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 23, 2011 at 05:40:17PM +0100, Eric Dumazet wrote:
> > -		call->filter = NULL;
> > +		rcu_assign_pointer(call->filter, NULL);
> 
> Its a minor point, but setting a pointer to NULL certainly doesnt need a
> smp_wmb() barrier, so you can use RCU_INIT_POINTER(call->filter, NULL);

Yeap, we don't need it for NULL.  Did that anyway for consistency /
documentation.  Didn't know we had a macro for that.  Neat.  Updating
the patch....

Thanks.

-- 
tejun
