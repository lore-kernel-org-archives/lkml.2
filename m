Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab1GZMZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:25:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36329 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1GZMZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:25:26 -0400
Subject: Re: [RFC][PATCH 6/7] sched: Balance RT tasks when forked as well
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110617015919.832743148@goodmis.org>
References: <20110617015516.301117218@goodmis.org>
	 <20110617015919.832743148@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Jul 2011 14:25:08 +0200
Message-ID: <1311683108.24752.33.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 21:55 -0400, Steven Rostedt wrote:
> +       /* For anything but wake ups, just return the task_cpu */
> +       if (sd_flag != SD_BALANCE_WAKE || sd_flag != SD_BALANCE_FORK) 

So we call select_task_rq() with SD_BALANCE_{WAKE,EXEC,FORK}, 

	(WAKE != WAKE -> 0 || WAKE != FORK -> 1) -> 1
	(EXEC != WAKE -> 1 ) -> 1
	(FORK != WAKE -> 1 ) -> 1

IOW, you never end up doing anything now.. surely you didn't mean that?!
