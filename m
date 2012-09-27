Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2I0CAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:00:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56127 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2I0CAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:00:47 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-a0-5063b33c87e7
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v2 3/4] perf annotate: configure objdump path at compile time
References: <1348428446-28245-1-git-send-email-irina.tirdea@gmail.com>
	<1348428446-28245-4-git-send-email-irina.tirdea@gmail.com>
	<1348578539.1877.40.camel@leonhard>
	<CANg8OW+u=dsi=5Y04ka0D=VLKEUELAo1L3mkWhs5mOqTS4c1jA@mail.gmail.com>
Date: Thu, 27 Sep 2012 10:52:14 +0900
In-Reply-To: <CANg8OW+u=dsi=5Y04ka0D=VLKEUELAo1L3mkWhs5mOqTS4c1jA@mail.gmail.com>
	(Irina Tirdea's message of "Thu, 27 Sep 2012 03:51:07 +0300")
Message-ID: <87d318w7u9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 03:51:07 +0300, Irina Tirdea wrote:
> On Tue, Sep 25, 2012 at 4:08 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>> I thought about it twice and confused.
>>
>> For cross-compiling, the resulting perf binary will run on target - say
>> Android - but the toolchain runs on host, right?  So with this change
>> the cross-built perf will try to find the arm-eabi-objdump on Android.
>> Is it an intended behavior?  Is there an arm-eabi-objdump on Android?
>>
>
> Apparently I got confused about this as well...

:)

>
> There are two perf binaries built for Android: one for the target
> (that will run on Android) and the other one for the host (that can be
> used to analyse data recorded on the target).
>
> As you mentioned, the perf built to run on Android needs to use
> objdump as "objdump" (actually Android does not yet have objdump, but
> this is the naming convention). In this case, objdump should not have
> the CROSS_COMPILE prefix.

Ok.

>
> The perf built to run on the host needs to use arm-eabi-objdump from
> the toolchain so that it can analyse data recorded on Android. This
> patch is targeting this scenario, not the previous one. In this case,
> the CROSS_COMPILE option would be different than arm-eabi- so using
> $(CROSS_COMPILE)objdump would be wrong. objdump should be overridden
> when running make since there is no connection between the toolchain
> used here and the path for objdump. I am always overriding objdump
> when calling make, so I did not catch this.
>
> I think that I should change DEFAULT_OBJDUMP_PATH=objdump in the
> Makefile to handle the first scenario. I'll also explain this in the
> commit message so that it is more clear and make the same change for
> the addr2line patch.
>
> What do you think?

I think the right thing to do is finding a correct objdump at runtime in
some way.  Why do you want to make it compile-time configurable?

Thanks,
Namhyung
