Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1GNOJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 10:09:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab1GNOJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 10:09:17 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=PY02sq4htjkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=40jEhcFK0yD2XDzs668A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [Question] sched: migrate RT task on throttled leaf RT
 runqueue?
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAJd=RBCB-GZh9jtWMkuJHQ5wJRJkMyCONh5JGH=DMpfco5juYg@mail.gmail.com>
References: <CAJd=RBCB-GZh9jtWMkuJHQ5wJRJkMyCONh5JGH=DMpfco5juYg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Jul 2011 10:09:12 -0400
Message-ID: <1310652552.27864.25.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 21:43 +0800, Hillf Danton wrote:
> Hi Steven
> 
> When a non-boosted RT task is enqueued, if it is attached to task group, as
> shown in the following diff format for clarity, and even if the RT runqueue
> owned by the task group is throttled, the rt_rq is loaded up as leaf and the
> task is added to pushable list if it is pushable.
> 
> Since RT tasks on throttled rt_runqueue will not be picked to be the next task
> when scheduling, could they be migrated by pushing and pulling?

Note, run queues are not throttled, groups are. And tasks on a throttled
group should not be touched by the push/pull algorithm.

-- Steve


