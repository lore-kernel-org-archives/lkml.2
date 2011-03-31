Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1CaD76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:59:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1818 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1CaD75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E+ZRlmj5zNoiYbKCC0r82GMv1k/inecog2U+LDXNbNab3R6UjcRynF9ZruzgQ1d64y
         yUrCW5d1niswEedYHJ5A==
MIME-Version: 1.0
In-Reply-To: <20110330183446.GG1291@redhat.com>
References: <BANLkTimiL5VZki4oUaw5hQYgB=E2jYwKrw@mail.gmail.com>
 <4D8C48B6.6050300@fusionio.com> <BANLkTimzt7QhBdayBpB3dRSOSY3G3VCfcw@mail.gmail.com>
 <20110330183446.GG1291@redhat.com>
From: Justin TerAvest <teravest@google.com>
Date: Wed, 30 Mar 2011 20:59:34 -0700
Message-ID: <BANLkTinKyWsB-Oj4B-tDWEV7SPxvi--RaQ@mail.gmail.com>
Subject: Re: Why do we use cpu nice priority for ioprio?
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:34 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 30, 2011 at 11:23:45AM -0700, Justin TerAvest wrote:
>> On Fri, Mar 25, 2011 at 12:48 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> > On 2011-03-25 03:38, Justin TerAvest wrote:
>> >> It's not clear why the cpu nice value should be mapped to the ioprio
>> >> for a task when none is picked.
>> >>
>> >> Internally, at cfq_init_prio_data(), we just set:
>> >>               ioprio = IOPRIO_NORM;
>> >>               ioprio_class = IOPRIO_CLASS_BE;
>> >> if ioprio_class is IOPRIO_CLASS_NONE.
>> >>
>> >>
>> >> The problem is that  today, SCHED_RR and SCHED_FIFO threads
>> >> automatically get bumped up to RT class. This all happens behind the
>> >> curtains and the io_class of the thread is still shown as NONE with
>> >> sys_ioprio_get(). What's the motivation behind this promotion of
>> >> ioprio class?
>> >
>> > It was decided back in the day when io priorities were introduced. I
>> > still think it's a good idea.
>>
>> This is the part I'm especially curious about. If we're managing the
>> resources separately,
>> why should be be adjusting io_class based on the nice value?
>
> What's wrong with taking a hint about ioclass and ioprio from cpu
> scheduling class and nice value?

I guess it's fine. I was just curious how strongly everyone felt about
the way it works today. It sounds like we expect nice values and io
scheduling classes to be closely matched.

Thanks,
Justin

>
> I think in general if some task is important from cpu perspective then
> most likely it is important from IO perspective too. And if user thinks
> otherwise, then one can explicitly set ioclass and ioprio of the task.
>
> So this makes sense to me.
>
> Thanks
> Vivek
>
