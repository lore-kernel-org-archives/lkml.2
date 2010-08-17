Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab0HQJFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:05:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57776 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0HQJFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JZiYGGFnvWVGEQCwFqUkXFJkETFm/jyiW0jrAu8BP7h6TaCRzfdV+hIudcYQ3Wj7UM
         7jSR+1dWeOG0KJ3YePxJNvvS7632uRhaGuw/Z6JcTZe0CDYaeH9fnrOlphh1dK6QuKs/
         eZRLZRaTXVujau2xiQ1pjuJowpuY5CJFtkjGc=
MIME-Version: 1.0
In-Reply-To: <20100817083945.GA12022@swordfish.minsk.epam.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
	<1281946970.1926.998.camel@laptop>
	<20100816133452.GS4879@redhat.com>
	<1281966418.1926.1421.camel@laptop>
	<20100816140829.GA5225@swordfish.minsk.epam.com>
	<20100817025954.GA12366@nowhere>
	<AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
	<20100817083945.GA12022@swordfish.minsk.epam.com>
Date: Tue, 17 Aug 2010 17:05:36 +0800
Message-ID: <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
From: Yong Zhang <yong.zhang0@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 4:39 PM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
>> Why not use __raw_get_cpu_var() instead?
>> You know adding preempt protection in touch_softlockup_watchdog()
>> just suppress the warning. Am I missing something?
>>
>
> Sorry, my low level understanding of the __raw_get_cpu_var isn't very strong.
> I assume it uses current_thread_info()->cpu in some cases (right?) or
> percpu_from_op.

The difference is __raw_get_cpu_var() is using raw_smp_processor_id().

>
>
> Should it be
> acpi_os_stall
>        preepmt_disable
>        touch_nmi_watchdog
>                touch_softlockup_watchdog
>        preempt_enable

Actually I don't think this is helpful for the whole function. Because
if acpi_os_stall()
migrate(I don't know if it could) to another CPU just before
preepmt_disable(), we'll
be on the wrong way. Adding preempt protection is just smoothing the warning.

So I prefer using __raw_get_cpu_var() as what we have been done before.

Thanks,
Yong
