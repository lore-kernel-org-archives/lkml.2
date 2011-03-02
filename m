Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab1CBCoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 21:44:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab1CBCo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 21:44:29 -0500
Message-ID: <4D6DAEF9.6000806@redhat.com>
Date: Tue, 01 Mar 2011 21:44:09 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: next buddy hint on sleep and preempt path
References: <1299022433-17233-1-git-send-email-venki@google.com>
In-Reply-To: <1299022433-17233-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 06:33 PM, Venkatesh Pallipadi wrote:
> When a task in a taskgroup sleeps, pick_next_task starts all the way back at
> the root and picks the task/taskgroup with the min vruntime across all
> runnable tasks. But, when there are many frequently sleeping tasks
> across different taskgroups, it makes better sense to stay with same taskgroup
> for its slice period (or until all tasks in the taskgroup sleeps) instead of
> switching cross taskgroup on each sleep after a short runtime.
> This helps specifically where taskgroups corresponds to a process with
> multiple threads. The change reduces the number of CR3 switches in this case.

Nice!

> Signed-off-by: Venkatesh Pallipadi<venki@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
