Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1C3SYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:24:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60737 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1C3SYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lF+dB663rAGYi2Htf6+Vk4TnE67gtOnj9252J9QnvmwXhJ+MWEyg9JuLucHdOhxIeJ
         LJec1ZDXg+jm6W5qqNgg==
MIME-Version: 1.0
In-Reply-To: <4D8C48B6.6050300@fusionio.com>
References: <BANLkTimiL5VZki4oUaw5hQYgB=E2jYwKrw@mail.gmail.com> <4D8C48B6.6050300@fusionio.com>
From: Justin TerAvest <teravest@google.com>
Date: Wed, 30 Mar 2011 11:23:45 -0700
Message-ID: <BANLkTimzt7QhBdayBpB3dRSOSY3G3VCfcw@mail.gmail.com>
Subject: Re: Why do we use cpu nice priority for ioprio?
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 12:48 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-03-25 03:38, Justin TerAvest wrote:
>> It's not clear why the cpu nice value should be mapped to the ioprio
>> for a task when none is picked.
>>
>> Internally, at cfq_init_prio_data(), we just set:
>>               ioprio = IOPRIO_NORM;
>>               ioprio_class = IOPRIO_CLASS_BE;
>> if ioprio_class is IOPRIO_CLASS_NONE.
>>
>>
>> The problem is that  today, SCHED_RR and SCHED_FIFO threads
>> automatically get bumped up to RT class. This all happens behind the
>> curtains and the io_class of the thread is still shown as NONE with
>> sys_ioprio_get(). What's the motivation behind this promotion of
>> ioprio class?
>
> It was decided back in the day when io priorities were introduced. I
> still think it's a good idea.

This is the part I'm especially curious about. If we're managing the
resources separately,
why should be be adjusting io_class based on the nice value?

> You could argue that auto-bumping up to
> IOPRIO_CLASS_RT is a bit heavy handed. But is it really that different
> from the CPU scheduling?

But why do auto bumping at all? Is this for convenience, so users only
have to nice their tasks?

>
> So, from memory, the difference between RR and FIFO on the CPU
> scheduling side is that one of them will relingiush the CPU for a brief
> period once in a while. Correct? That does not happen for
> IOPRIO_CLASS_RT. So at least from that perspective, it's not a complete
> match and might be a cause for concern.
>
> --
> Jens Axboe
>
>
