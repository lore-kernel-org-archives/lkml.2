Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1F3NNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:13:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36632 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1F3NNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:13:13 -0400
MIME-Version: 1.0
In-Reply-To: <1309438526.26417.65.camel@gandalf.stny.rr.com>
References: <BANLkTikH9cdO+bwNN4kGgisP6RCy2Xo-3g@mail.gmail.com>
	<1309438526.26417.65.camel@gandalf.stny.rr.com>
Date: Thu, 30 Jun 2011 21:13:12 +0800
Message-ID: <BANLkTi=xw04C7k7g9k7uaeGBmsz9h+Vydw@mail.gmail.com>
Subject: Re: [RFC] sched: check RT runqueue overloaded in tick timer
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 8:55 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-06-30 at 20:47 +0800, Hillf Danton wrote:
>> Hi Steven
>>
>> When tick timer runs, runqueue overload is checked. If overloaded and other
>> CPUs available at the moment, reschedule is fired to allow push logic to move
>> the pushable tasks somewhere else.
>
> Why?
>
> This would be a waste of overhead. We check when a task is queued and
> dequeue, and when a cpu lowers its priority (for a pull). There's no
> need to randomly check if we need to push or pull based on timers.
> That's just going to slow things down.
>
Got it.

If puller is inactive, there is no CPU available for the pushable.

Thanks
Hillf
