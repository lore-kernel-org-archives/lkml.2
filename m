Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab2LKMKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:10:13 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43921 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2LKMKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:10:10 -0500
MIME-Version: 1.0
In-Reply-To: <1355149273.17101.176.camel@gandalf.local.home>
References: <CAJd=RBCk0eWQqTk-BX8_=aBdYEQnbnf57dHZdcVbWbVY=33OhQ@mail.gmail.com>
	<1355149273.17101.176.camel@gandalf.local.home>
Date: Tue, 11 Dec 2012 20:10:09 +0800
Message-ID: <CAJd=RBDprA5ruzY6-uQ3L5eSX3Muk8fSpQZbbmsK0oAGwk0WtQ@mail.gmail.com>
Subject: Re: [RFC PATCH] sched: rt: fix selecting runqueue for task to be pushed
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 10:21 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-12-10 at 20:19 +0800, Hillf Danton wrote:
>> When we are trying to push task out, no point to select the last cpu that
>> the given task executed on, which is fixed by selecting target cpu with
>> cache affinity concerned, and with SD_WAKE_AFFINE ignored as we are not
>> handling sleeper.
>
> I have to ask. Why?
>
> The check you are skipping is if the task is running on a CPU that is
> already the lowest CPU priority (lowest_mask returns the CPUs running
> tasks of the lowest priority in the system).

Hm ... how do you get the lowest mask for a pushable task iff
that check makes sense?

> Which means that either the
> task that we are pushing is the same priority or lesser priority than
> what is running on the other CPUs. Either case, this task wont push out
> a task on the other CPUs because it's not higher priority than those
> tasks.
>
> You just added more work for the same result (no push).
>
> -- Steve
>
>
