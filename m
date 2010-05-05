Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934382Ab0EEJub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:50:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40510 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934157Ab0EEJu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:50:29 -0400
Subject: Re: [PATCH 03/12] perf: add perf_event_task_migrate()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu, efault@gmx.de,
       avi@redhat.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BE13C76.2010507@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272976724-14312-4-git-send-email-tj@kernel.org>
	 <20100505050846.GG5427@nowhere> <1273050684.1642.231.camel@laptop>
	 <4BE13C76.2010507@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 11:50:25 +0200
Message-ID: <1273053025.1642.234.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 11:37 +0200, Tejun Heo wrote:
> On 05/05/2010 11:11 AM, Peter Zijlstra wrote:
> > On Wed, 2010-05-05 at 07:08 +0200, Frederic Weisbecker wrote:
> >>
> >> In fact why not moving both tracing calls under this check.
> >> This is going to fix the migrate trace event that gets called
> >> even on "spurious" migrations, and you avoid the duplicate check
> >> in the perf callback. 
> > 
> > I kept the tracepoint out of that because I wanted to see how often it
> > attempts silly migrations :-)
> 
> Do you still need to keep it or is it okay to move it under the
> silliness check?

I guess you can move it, I often end up adding tons of trace_printk()
anyway when hunting funnies, might as well add one here when its
relevant.

