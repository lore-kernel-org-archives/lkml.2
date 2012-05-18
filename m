Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639Ab2ERKAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:00:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:54209 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762581Ab2ERKAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:00:43 -0400
Message-ID: <1337335233.573.6.camel@twins>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 18 May 2012 12:00:33 +0200
In-Reply-To: <1332340496-21658-2-git-send-email-bp@amd64.org>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
	 <1332340496-21658-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 15:34 +0100, Borislav Petkov wrote:
> @@ -6319,6 +6332,10 @@ __perf_event_exit_task(struct perf_event *child_event,
>                 raw_spin_unlock_irq(&child_ctx->lock);
>         }
>  
> +       /* do not remove persistent events on task exit */
> +       if (child_event->attr.persistent)
> +               return;
> +
>         perf_remove_from_context(child_event);
>  

Huh, the task it dying, why would you let the event stay in the task
context?
