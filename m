Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1I0SmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:42:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5260 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1I0SmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:42:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=dYyeZhnnMzeWQh4F8nH51YWJg53ZgHrvoYhOz+JC0Wr+bkI6hshXEV9r/uYcmloX2
	U5aI03eRV/7ZczRVo8XWA==
MIME-Version: 1.0
In-Reply-To: <4E820E4D.5050205@am.sony.com>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
	<4E820E4D.5050205@am.sony.com>
Date: Tue, 27 Sep 2011 11:42:06 -0700
X-Google-Sender-Auth: WnD79m3HaXk5s6m4N4X79dthVc8
Message-ID: <CAPnjgZ0hoM4b4vt6THyO54xBo_YTGmg14P5a48sQPkkeR00-5Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
From: Simon Glass <sjg@chromium.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Tue, Sep 27, 2011 at 10:56 AM, Tim Bird <tim.bird@am.sony.com> wrote:
> On 09/23/2011 04:03 PM, Simon Glass wrote:
>> This experimental patch set adds boot timing to a Linux system. The
>> timing starts with the boot loader and extends through the kernel into
>> user space to the completion of the boot process. The timing starts when
>> the system leaves reset, not later when the kernel starts.
>
> I would be very interested in this.  This is something that
> would be very helpful, I believe, to assist with optimizing
> overall boot time.

Good.

>
>> Finally, in user space there is no kernel-blessed way to record
>> timestamps. One approach is to add lines to the init scripts like
>> 'cat /proc/uptime >/tmp/login_starts'.
>> This creates another place where
>> the boot timing tool must look for information.
>
> 'cat /proc/uptime >/dev/kmsg' (with printk timestamps on) is much
> better than the above, for this reason.

Yes, although this needs root access on my machine. Am hoping to have
something easily accessible from user space.

>
>> This Patchset
>> -------------
>> This patchset aims to unify timing in one place: a simple driver which
>> collects pre-kernel boot timestamps, adds its own as it boots, with
>> calls to bootstage_mark(), then allows user space (init, etc.) to add
>> more with 'echo "message" >>/sys/kernel/debug/bootstage/mask'.
>>
>> Finally it permits user space to access the full list of timestamps
>> with 'cat /sys/kernel/debug/bootstage/report', which has two columns:
>> the stage name and the timestamp:
>>
>>       reset   0
>>       arch_cpu_init-AVP       258902
>>       arch_cpu_init-A9        263267
>>       arch_cpu_init-done      263312
>>       board_init_f-start      263314
>>       board_init_r-start      323671
>>       main_loop       573008
> ...
>
> I would prefer the timestamp in the first column.  Also, for consistency
> it would be good if it used the same format as printk timestamps:
> "[%5lu.%06lu]" with seconds and micro-seconds in the respective fields.
> Then, existing tools like scripts/show_delta and scripts/bootgraph.pl
> could work on this data as well.

Yes that makes sense, I will adjust it.

>
> Full micro-second granularity is not required, but it's nice to keep
> the format the same, whether the clock supports it or not.

Yes, and it's surprising how often microsecond accuracy is useful. For
example, recently I was looking at the impact of reduced
voltage/frequency early in boot on an ARM platform. The difference was
only a few ms, and the microsecond timer resolution helped a lot in
seeing the impact of these changes.

>
> Finally, is this work related at all to this:
> http://lists.denx.de/pipermail/u-boot/2011-September/099996.html
> Bootgraph.pl instrumentation support for UBoot
> ??
>
> Just wondering.

It is related in the sense that ideally all of this would come
together and play nicely. That's an interesting patch also, and there
are a few threads to tie together in U-Boot independently of the
kernel.

My original U-Boot patch set was here:

http://lists.denx.de/pipermail/u-boot/2011-May/092584.html

>
> Thanks - this looks like great stuff!

Thanks!

Regards,
Simon

>  -- Tim
>
> =============================
> Tim Bird
> Architecture Group Chair, CE Workgroup of the Linux Foundation
> Senior Staff Engineer, Sony Network Entertainment
> =============================
>
>
