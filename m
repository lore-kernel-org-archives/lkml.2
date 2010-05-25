Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0EYIT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:19:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0EYIT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:19:57 -0400
Subject: Re: [PATCH 1/5] perf: Disallow mmap() on per-task inherited events
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100525005528.GB30395@drongo>
References: <20100518133258.000434886@chello.nl>
	 <20100518133725.885757039@chello.nl>  <20100525005528.GB30395@drongo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 10:19:41 +0200
Message-ID: <1274775581.5882.503.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 10:55 +1000, Paul Mackerras wrote:
> On Tue, May 18, 2010 at 03:32:59PM +0200, Peter Zijlstra wrote:
> 
> > Since we now have working per-task-per-cpu events for a while,
> > disallow mmap() on per-task inherited events. Those things were
> > a performance problem anyway, and doing away with it allows
> > us to optimize the buffer somewhat by assuming there is only a single
> > writer.
> 
> This also disallows user-space access to hardware counter for this
> event -- which is arguably OK, since doing the userspace read would
> give a different answer to read() on the event fd, as the read() sums
> up all the child counters for us.  Nevertheless, I think this
> side-effect is worth mentioning.

Right, using rdpmc (and similar) should be strictly limited to strict
self-monitoring.
