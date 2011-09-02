Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab1IBH0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:26:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63779 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab1IBH03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:26:29 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.92.201]
In-Reply-To: <201108221027.34441.trenn@suse.de>
References: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
	<201108192231.02665.trenn@suse.de>
	<CACVXFVPeFyg7YoAsY63Mpy9HVR1y3ibg9R8HnUfLVe=hKf3ApA@mail.gmail.com>
	<201108221027.34441.trenn@suse.de>
Date: Fri, 2 Sep 2011 09:26:28 +0200
Message-ID: <CAORVsuVkxHTEr5J9F1USr3csMoCELDfk9ixeG3kddy6oRj5RUw@mail.gmail.com>
Subject: Re: [PATCH 3/3] trace points: power: remove 'cpu_id' from trace_cpu_idle
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Thomas Renninger <trenn@suse.de>, Ming Lei <tom.leiming@gmail.com>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei, Thomas,

Sorry if it is a bit late to jump in.

On Mon, Aug 22, 2011 at 10:27 AM, Thomas Renninger <trenn@suse.de> wrote:
> On Saturday, August 20, 2011 04:40:09 AM Ming Lei wrote:
>> Hi,
>>
>> 2011/8/20 Thomas Renninger <trenn@suse.de>:
>> > On Friday, August 19, 2011 05:04:04 PM tom.leiming@gmail.com wrote:
>> >> From: Ming Lei <tom.leiming@gmail.com>
>> >>
>> >> This patch removes the 'cpu_id' parameter of the cpu_idle
>> >> trace point, based on the ideas below:
>> >>
>> >> - the cpu_id which is passed to trace point is always the current
>> >>   cpu
>> > Are you sure this will always be true?
>>
>> It is sure at least now,  the only place to pass 'dev->cpu' is inside
>> cpuidle_idle_call,
> It was known that cpu_id is always the current cpu with current
> implementation when this got introduced.
> But the perf events API must not change back and forth for userspace
> compatibility. Therefore the cpu_id was added in case
> that future implementations want to pass info where the current cpu
> is not the cpu which is sent to the sleep state.
Agree. Let's keep the cpu_id field.

>
>> smp_processor_id() can't be used safely in preemptible context.
> I expect the only side effect that could happen is that if smp_process_id
> is interrupted you get the wrong core id on a cpu idle trace event.
> This only happens if cpuidle is not used and even then should happen
> very rarely, nothing to worry for a debug tool like that.
> And it should get fixed if these idle functions get fully integrated into
> cpuidle at some point of time.
>
>   Thomas
>

Regards,
Jean
