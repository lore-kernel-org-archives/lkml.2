Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab0EYBHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:07:18 -0400
Received: from ozlabs.org ([203.10.76.45]:48455 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758501Ab0EYBHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:07:16 -0400
Date: Tue, 25 May 2010 10:55:28 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf: Disallow mmap() on per-task inherited events
Message-ID: <20100525005528.GB30395@drongo>
References: <20100518133258.000434886@chello.nl>
 <20100518133725.885757039@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518133725.885757039@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 03:32:59PM +0200, Peter Zijlstra wrote:

> Since we now have working per-task-per-cpu events for a while,
> disallow mmap() on per-task inherited events. Those things were
> a performance problem anyway, and doing away with it allows
> us to optimize the buffer somewhat by assuming there is only a single
> writer.

This also disallows user-space access to hardware counter for this
event -- which is arguably OK, since doing the userspace read would
give a different answer to read() on the event fd, as the read() sums
up all the child counters for us.  Nevertheless, I think this
side-effect is worth mentioning.

Paul.
