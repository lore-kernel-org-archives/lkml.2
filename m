Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1FDFLz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 01:11:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39466 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1FDFLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 01:11:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nxlSv0S0MovdL9rV3yPZkNWXCjOcxdXqMWYLfdwUCjx3rJ3C+Jn2MUwBrq6GIegalx
         wzevi9U1hrcyjoQkvvhFx4kFqOWn7OzY8icWTfxf3uhgUMjS7DSONV4GE2P/DIbxstp5
         rTMRotxsX3RKrPxoqc+9lBFg370K6IDjQPrjs=
MIME-Version: 1.0
In-Reply-To: <1307163988.31814.11.camel@gandalf.stny.rr.com>
References: <BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com>
	<1306852804.11899.19.camel@gandalf.stny.rr.com>
	<BANLkTikzjVd69XRb6psBm1aYSem126YynA@mail.gmail.com>
	<1307163988.31814.11.camel@gandalf.stny.rr.com>
Date: Sat, 4 Jun 2011 13:11:52 +0800
Message-ID: <BANLkTim+3ZzqBfWNzks96sm89O4o2c2_Yw@mail.gmail.com>
Subject: Re: [PATCH] sched: remove the next highest_prio in RT scheduling
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 4, 2011 at 1:06 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2011-06-04 at 12:44 +0800, Hillf Danton wrote:
>
>> Both the next and curr reach same result, or incorrect result, before locking
>
> Not quite. curr could be of higher priority than this rq, but next be of
> lower priority. In that case, we still want to skip the rq.
>
> But this patch does simplify things, and I give you credit for that.
> I'll have to run some tests to see how much in practice this occurs, and
> see if it is worth removing and using your method instead.
>
Hi Steve

Big surprise, you work on Saturday!

good weekend

Hillf
>
>> RQ, as the comment says, it is racy. After locking RQ, priority is checked again
>> to pull the correct tasks with no running task included. The difference between
>> the next and curr before locking RQ is the core of the patch that incorrect
>> result could be achieved with no updating the next field.
>>
>> thanks
>>            Hillf
>
>
>
