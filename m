Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab0KZT7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:59:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:59628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab0KZT7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:59:41 -0500
Message-ID: <4CF0118B.1040708@kernel.org>
Date: Fri, 26 Nov 2010 20:59:07 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 02/14] freezer: fix a race during freezing of TASK_STOPPED
 tasks
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-3-git-send-email-tj@kernel.org> <201011262040.27854.rjw@sisk.pl>
In-Reply-To: <201011262040.27854.rjw@sisk.pl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 19:59:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2010 08:40 PM, Rafael J. Wysocki wrote:
> On Friday, November 26, 2010, Tejun Heo wrote:
>> After calling freeze_task(), try_to_freeze_tasks() see whether the
>> task is stopped or traced and if so, considers it to be frozen;
>> however, nothing guarantees that either the task being frozen sees
>> TIF_FREEZE or the freezer sees TASK_STOPPED -> TASK_RUNNING
>> transition.  The task being frozen may wake up and not see TIF_FREEZE
>> while the freezer fails to notice the transition and believes the task
>> is still stopped.
>>
>> This patch fixes the race by making freeze_task() always go through
>> fake_signal_wake_up() for applicable tasks.  The function goes through
>> the target task's scheduler lock and thus guarantees that either the
>> target sees TIF_FREEZE or try_to_freeze_task() sees TASK_RUNNING.
> 
> Looks good.  I'll take this one to my tree, if you don't mind.

Sure thing.

Thanks.

-- 
tejun
