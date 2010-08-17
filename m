Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab0HQJhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:37:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47475 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab0HQJhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ROUMnUmvTEyxeOtHJ7gAJHbdbhx+HcaxS4eBQmjaxpwfE528a+790DXuyKNLlc7Gkh
         o4Su6BQ29Czovz4f38YvJj+01GhqknG/Xu+B5mtFybf9l0YWa1Gfx8TaoOCStpFYm9qq
         BkWxlF4U58SEq3agh/TI/oaNaNokiwklDdD4A=
MIME-Version: 1.0
In-Reply-To: <20100817092407.GB12022@swordfish.minsk.epam.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
	<1281946970.1926.998.camel@laptop>
	<20100816133452.GS4879@redhat.com>
	<1281966418.1926.1421.camel@laptop>
	<20100816140829.GA5225@swordfish.minsk.epam.com>
	<20100817025954.GA12366@nowhere>
	<AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
	<20100817083945.GA12022@swordfish.minsk.epam.com>
	<AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
	<20100817092407.GB12022@swordfish.minsk.epam.com>
Date: Tue, 17 Aug 2010 17:37:34 +0800
Message-ID: <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
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

On Tue, Aug 17, 2010 at 5:24 PM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
> OK. Suppose (I don't know if it could) migration has happen
>
> acpi_os_stall
>        __migration__
>        touch_nmi_watchdog
>
> How calling raw_smp_processor_id() (which is current_thread_info()->cpu)
> vs. preepmt_disable - smp_processor_id() will give us different CPUs?

I don't mean you will get different CPUS(sorry for my poor english).
I mean if the migration could happen, you want to touch_nmi_watchdog()
on CPU A(otherwise the watchdog will shout on us), but eventually we
touch_nmi_watchdog() on CPU B(because of migration),
and this is not what we want.

So preempt_disable() is redundant here.

>
>> So I prefer using __raw_get_cpu_var() as what we have been done before.
>>
>
> Hm...
>
> 26e09c6eee14f4827b55137ba0eedc4e77cd50ab

f69bcf60c3f17aa367e16eef7bc6ab001ea6d58a
2508ce1845a3b256798532b2c6b7997c2dc6533b

you can get the previous touch_*_watchdog there.

Thanks,
Yong
