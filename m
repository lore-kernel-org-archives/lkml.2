Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab1EROy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:54:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49532 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab1EROy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:54:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nXFWsY7ia+I19ePoiK3wev9o9O09WyEgmZrHlp0N6bpdOmVe3zOdSNCLU3dTKR7iou
         NjyUbICg/EZVakSaxuvJhItHerj05MI+PibcDGuQjDQB8aibARi99b35GKLKeKQS7uGX
         +v7JajtSzOORCqVh/qNzTwsS1z4O9fY1Cd2Wk=
MIME-Version: 1.0
In-Reply-To: <1305725244.26849.13.camel@gandalf.stny.rr.com>
References: <BANLkTintLhxVQvbmt6oJQ9Zbcmen7yL3ug@mail.gmail.com>
	<1305725244.26849.13.camel@gandalf.stny.rr.com>
Date: Wed, 18 May 2011 22:54:55 +0800
Message-ID: <BANLkTingJ7s5SR+QWuE=_P5tcbuaB_bEwQ@mail.gmail.com>
Subject: Re: [PATCH] sched: change pull_rt_task() to decrease time waiting on runqueue
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 9:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-05-18 at 20:57 +0800, Hillf Danton wrote:
>> It is changed to be pushing RT task, then the pushable tasks on other
>> runqueus have chances to reach all CPUS whose runqueus are lower in
>> priority, which is not covered by pull since only one runqueue is
>> considered in pull for accepting tasks on other runqueues. Thus the
>> time of pushable tasks waiting on runqueue could be decreased.
>
> Do you have numbers and test cases for this? Or at least traces that
> show how this helps?
>
> Basically, you are saying that we want to iterate over all CPUs and have
> them go through the algorithm of searching for rqs that they can push
> to. But we already know that our run queue has dropped priority.
>
> I'm not fully understanding the benefit of this patch.
>

Hi Steve

In short, if there are pushable tasks and if there are RQs,
NOT LIMITED TO our RQ, in lower priority, tasks should be pushed to
RQs as many as we could.

Hillf
