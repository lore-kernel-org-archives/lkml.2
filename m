Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946168Ab2CPX6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:58:54 -0400
Received: from forward7.mail.yandex.net ([77.88.61.37]:60607 "EHLO
	forward7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945934Ab2CPX6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:58:48 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <944171329661049@web81.yandex.ru>
References: <1322774765.8386.2.camel@hp> <20120213172316.GA24145@home.goodmis.org> <944171329661049@web81.yandex.ru>
Subject: Re: [PATCH]sched_rt.c: Avoid unnecessary dequeue and enqueue of pushable tasks in set_cpus_allowed_rt()
MIME-Version: 1.0
Message-Id: <654301331942324@web109.yandex.ru>
Date: Sat, 17 Mar 2012 03:58:44 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven, what is about the patch from my previous message? Is everything ok?

Regards,
Kirill

19.02.2012, 18:17, "Kirill Tkhai" <tkhai@yandex.ru>:
> 13.02.2012, 21:23, "Steven Rostedt" <rostedt@goodmis.org>:
>
>> šI wasn't on the Cc of the original message, but it was bounced to me
>> šawhile ago. I'm cleaning out my email and came across it.
>>
>> šCan you send me the latest version of this patch, either against latest
>> šLinus, or against tip/master.
>>
>> šThanks,
>>
>> š-- Steve
>>
>> šP.S. I'll be at ELC this week so it may not get processed right away.
>
> Migration status depends on a difference of weight from 0 and 1.
> If weight > 1 (<= 1) and old weight <= 1 (> 1) then task becomes
> pushable (or not pushable). We are not insterested in its exact
> values, is it 3 or 4, for example.
>
> Now if we are changing affinity from a set of 3 cpus to a set of 4, the-
> task will be dequeued and enqueued sequentially without important
> difference in comparison with initial state. The only difference is in
> internal representation of plist queue of pushable tasks and the fact
> that the task may won't be the first in a sequence of the same priority
> tasks. But it seems to me it gives nothing.
>
> Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>
