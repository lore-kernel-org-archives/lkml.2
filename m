Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1HWBRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 21:17:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20946 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1HWBRM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 21:17:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=L6cBHMGyyvT7eRI58IFV8NzVTrXWTfRRAJZk4R6pikRMKBcN4rm7QVvHxTW5DyOy0
	Wc1jR14+4SeHQq7g5A4uA==
MIME-Version: 1.0
In-Reply-To: <1314060540.15704.143.camel@gandalf.stny.rr.com>
References: <1313531179-9323-4-git-send-email-vnagarnaik@google.com>
 <1314050999-10409-1-git-send-email-vnagarnaik@google.com> <1314060540.15704.143.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 22 Aug 2011 18:16:39 -0700
Message-ID: <CAL26m8+g=04gZ1Gi4LTNsQuN+92RH1F_uNTzMMT00DYHqJ5BJQ@mail.gmail.com>
Subject: Re: [PATCH v3] trace: Add per_cpu ring buffer control files
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 5:49 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-08-22 at 15:09 -0700, Vaibhav Nagarnaik wrote:
>>
>> @@ -3740,10 +3757,6 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>>           !cpumask_test_cpu(cpu, buffer_b->cpumask))
>>               goto out;
>>
>> -     /* At least make sure the two buffers are somewhat the same */
>> -     if (buffer_a->pages != buffer_b->pages)
>> -             goto out;
>> -
>>       ret = -EAGAIN;
>>
>>       if (ring_buffer_flags != RB_BUFFERS_ON)
>> @@ -3758,6 +3771,12 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>>       cpu_buffer_a = buffer_a->buffers[cpu];
>>       cpu_buffer_b = buffer_b->buffers[cpu];
>
> I would move the cpu_buffer_(ab) assignments up instead, as I want the
> EINVAL to have dominance. The record_disable just says that we are
> temporarily out of commission, when in fact it could be invalid. Thus
> the invalid conditions need to be treated first.
>
> -- Steve
>

Sure. I am sending an updated patch.


Vaibhav Nagarnaik
