Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab1GBEhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 00:37:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52601 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1GBEhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 00:37:50 -0400
MIME-Version: 1.0
In-Reply-To: <4E0E8107.4090300@google.com>
References: <1309545711.4303.2.camel@localhost.localdomain>
	<4E0E8107.4090300@google.com>
Date: Sat, 2 Jul 2011 10:37:49 +0600
Message-ID: <CADZ9YHi2=2TWKBJhiRdikc505qcEyuhmYm2_o70EXDsnHoT6nw@mail.gmail.com>
Subject: Re: [PATCH] sched: Check nr_running before calling pick_next_task in schedule().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sat, Jul 2, 2011 at 8:23 AM, Paul Turner <pjt@google.com> wrote:
> Hi Rakib,
>
> This doesn't strike me as a very good trade.
>
I'm not sure why. What am I missing here?

> It adds a branch to the case where we actually have work to save branches in
> the case when we're idle anyway?

Yes, right. We're adding a branch here. Is it a misuse of branch? As I
mentioned, idle_balance can fail (I think thats an unlikely case, that
why I've added a branch). In that case, we don't need to call
pick_next_task. Note, in pick_next_task there is a check for
'likely(rq->nr_running == rq->cfs.nr_running)' - by using this patch
that case will be more likely (which itself calls
fair_sched_class.pick_next_task directly - which is an optimization).
If calling  fair_sched_class.pick_next_task in case of all tasks are
cfs task is being treat as an optimization then why, when we're idle
calling idle_sched_class.pick_next_task, won't be an optimization?

Thanks,
Rakib

>
> - Paul
>
