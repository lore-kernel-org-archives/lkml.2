Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1FCPV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:21:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49285 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1FCPV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b9ChWDXHzHmy2gi0fwjkp+v3Es0DsqQlhfNPMFUhO6fctYqUugNEaCN4wb0MLjaxfQ
         wj6MBv3YzaYo0haIPmqw420l/pQLMlXMeD0a1ykyQFFzxlFVhfV9Ycu9BIfJPpYQNqmR
         z5fu62soXo8wIGFKrGjzLZ+RLFZaFJ/1RUtKM=
MIME-Version: 1.0
In-Reply-To: <1307112724.3667.58.camel@gandalf.stny.rr.com>
References: <BANLkTikoVj42S1iBHU_xFEpuGxY+TqmweA@mail.gmail.com>
	<1307110767.3667.51.camel@gandalf.stny.rr.com>
	<BANLkTim-tr+LAg1pA-wEFvVGiCvOYdfDoQ@mail.gmail.com>
	<1307112724.3667.58.camel@gandalf.stny.rr.com>
Date: Fri, 3 Jun 2011 23:21:57 +0800
Message-ID: <BANLkTik60sZNK6=CXte57O8Cs4ohU_fvVA@mail.gmail.com>
Subject: Re: [PATCH] sched: fix conflict of schedule domain balance in RT scheduling
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 10:52 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-06-03 at 22:30 +0800, Hillf Danton wrote:
>
>> I note the comment related to cache-hot, it is fine for woken task even though
>> cache-hot is considered to be nop for RT task,
>
> I would not say cache-hot is a nop for RT tasks. Although RT tasks
> should not depend on cache being hot, we don't want to go out of our way
> to hurt RT tasks.
>
>
>>  but what dose it help pushing
>> RT tasks waiting on RQ?
>
> What the lowest_mask returns is a mask of all cpus with the lowest
> priority. Due to the double_lock_balance() we could have unlocked the rq
> lock, and things could have changed. Thus, the current CPU could have
> lowered its priority. Unlikely to be the case, but can happen.
>

I am not sure task switch could happen due to RQ unlock.
If no switch, how priority is lowered?

thanks
            Hillf


> If the lowest_mask has the task's CPU set, why push this RT task
> somewhere else? Most likely the current CPU will not be set, but lets
> not punish the RT task if it is.
>
> -- Steve
>
>
>
>
