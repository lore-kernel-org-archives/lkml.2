Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1BBWtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:49:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53604
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442Ab1BBWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:49:48 -0500
Date: Wed, 02 Feb 2011 14:50:23 -0800 (PST)
Message-Id: <20110202.145023.183036454.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        fweisbec@gmail.com, mathieu.desnoyers@efficios.com
Subject: Re: [PATCH 1/2] tracing: Replace trace_event struct array with
 pointer array
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110202180938.106599012@goodmis.org>
References: <20110202180613.978219945@goodmis.org>
	<20110202180938.106599012@goodmis.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 02 Feb 2011 13:06:14 -0500

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Currently the trace_event structures are placed in the _ftrace_events
> section, and at link time, the linker makes one large array of all
> the trace_event structures. On boot up, this array is read (much like
> the initcall sections) and the events are processed.
> 
> The problem is that there is no guarantee that gcc will place complex
> structures nicely together in an array format. Two structures in the
> same file may be placed awkwardly, because gcc has no clue that they
> are suppose to be in an array.
> 
> A hack was used previous to force the alignment to 4, to pack the
> structures together. But this caused alignment issues with other
> architectures (sparc).
> 
> Instead of packing the structures into an array, the structures' addresses
> are now put into the _ftrace_event section. As pointers are always the
> natural alignment, gcc should always pack them tightly together
> (otherwise initcall, extable, etc would also fail).
> 
> By having the pointers to the structures in the section, we can still
> iterate the trace_events without causing unnecessary alignment problems
> with other architectures, or depending on the current behaviour of
> gcc that will likely change in the future just to tick us kernel developers
> off a little more.
> 
> The _ftrace_event section is also moved into the .init.data section
> as it is now only needed at boot up.
> 
> Suggested-by: David Miller <davem@davemloft.net>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: David S. Miller <davem@davemloft.net>
