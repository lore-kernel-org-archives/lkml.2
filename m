Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1GYSHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:07:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1GYSHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:07:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=YDjxXWm3eezD0J//qXJgLhmf5H3GO6qlKG4UJ4t83sn/xihsRHJ+gGvnjXt5Sdsuq
	VEP1/JMXC80cr8a+e4iuQ==
MIME-Version: 1.0
In-Reply-To: <1311602491.3526.16.camel@gandalf.stny.rr.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
 <1310785241-3799-3-git-send-email-vnagarnaik@google.com> <1311602491.3526.16.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 25 Jul 2011 11:06:58 -0700
Message-ID: <CAL26m8LtBr7i_MmTS23PJA9qMnvWMcmmcU3sO0pj1qg2CiogOg@mail.gmail.com>
Subject: Re: [PATCH 3/4] trace-cmd: Handle opcode parsing error
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 7:01 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-07-15 at 20:00 -0700, Vaibhav Nagarnaik wrote:
>>
>>  /* Note, *tok does not get freed, but will most likely be saved */
>> @@ -1706,7 +1706,10 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
>>               arg->op.op = token;
>>               arg->op.left = left;
>>
>> -             set_op_prio(arg);
>> +             if (-1 == set_op_prio(arg)) {
>
> I'm fine with the patch up to here. I understand the constant first
> compare, but it doesn't make sense here. Either use:
>
>        if (set_op_prio(arg) < 0) ...
>  or
>        if (set_op_prio(arg) == -1)...
>
>
> The reason the -1 == doesn't make sense is because:
>
>        if (set_op_proi(arg) = -1)
>
> would fail too.
>
> And it is much easier to read.
>
> -- Steve
>

Sure. I am sending the updated patch.

>> +                     event->flags |= EVENT_FL_FAILED;
>> +                     goto out_free;
>> +             }
>>
>>               type = read_token_item(&token);
>>               *tok = token;
>
>
>

Vaibhav Nagarnaik
