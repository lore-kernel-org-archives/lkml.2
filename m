Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab1FQNAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:00:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33639 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab1FQNAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qEVh5gjdHSXYigIyvQ1crJivXPdRXyWsKyv9NqXTVVuyEXimAFazWLOw9ES6aXRZEY
         t3sfZozhPZLLWGy5OsiFcU8u3I7uyw2tCtzn6qFPcswk7IaLpTyAjTrF7e96vOCATTlU
         8rXkRIPixapEVezpiUWPWDtR6Y39y5F20WfP4=
MIME-Version: 1.0
In-Reply-To: <1308275405.9218.156.camel@gandalf.stny.rr.com>
References: <BANLkTint_00+oHVGpgV4n4E2A9W5O8nJxA@mail.gmail.com>
	<1308275405.9218.156.camel@gandalf.stny.rr.com>
Date: Fri, 17 Jun 2011 20:59:59 +0800
Message-ID: <BANLkTik8PpdwGgLOE7rAauXqGYdnT53GpQ@mail.gmail.com>
Subject: Re: [PATCH] sched: update cpupri for runqueue when its priority changes
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 9:50 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sun, 2011-06-05 at 17:54 +0800, Hillf Danton wrote:
>> When the priority of runqueue changes, lower or higer, the info of cpupri
>> should be updated, in cases such as pick_next_task_rt() and switched_to_rt().
>
> Why?
>
> We do the calculation on queuing and dequeuing the task, we only care
> about the highest priority task that is on the queue, not what is
> actually running.
>

It is to capture the changes in CPU priority caused by re-queued task and
throttled RQ.

Hillf
