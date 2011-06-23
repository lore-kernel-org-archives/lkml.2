Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000Ab1FWRzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:55:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58736 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab1FWRzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:55:07 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=A9OGg-uhPlIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=b8DhMj-Jp-EtyGZUsooA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] sched: update rto_mask for RT runqueue
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <BANLkTin8EF5ZpWmXKGwbZqTf5+GZBBFhfQ@mail.gmail.com>
References: <BANLkTin8EF5ZpWmXKGwbZqTf5+GZBBFhfQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Jun 2011 13:55:06 -0400
Message-ID: <1308851706.531.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 21:43 +0800, Hillf Danton wrote:
> Hi Steven
> 
> Since {de, en}queue_pushable_task() is not always accompanied with
> {dec, inc}_rt_migration(), when the last pushable RT task on RQ is picked in
> pick_next_task_rt(), we have to update rto_mask for the RQ in question, which
> helps puller that is guided by rto_mask.

Hmm, I don't care much for this patch, but you did bring up something
that is interesting. That there may be a disconnect between the rto_mask
and the pushable tasks. A pushable task is the same as a pullable task.
So I'm thinking about revamping this to merge the two and make the code
simpler.

This may take a lot of testing to make sure that we did not create any
regressions.

-- Steve


