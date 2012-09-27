Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab2I0LZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:25:33 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47333 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2I0LZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:25:31 -0400
MIME-Version: 1.0
In-Reply-To: <87d318w7u9.fsf@sejong.aot.lge.com>
References: <1348428446-28245-1-git-send-email-irina.tirdea@gmail.com>
 <1348428446-28245-4-git-send-email-irina.tirdea@gmail.com>
 <1348578539.1877.40.camel@leonhard> <CANg8OW+u=dsi=5Y04ka0D=VLKEUELAo1L3mkWhs5mOqTS4c1jA@mail.gmail.com>
 <87d318w7u9.fsf@sejong.aot.lge.com>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Thu, 27 Sep 2012 14:25:10 +0300
Message-ID: <CANg8OWLR64RQYMwi=vx78tWBfcML4CPrerXV3nE+ngYkJ3Ru=A@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] perf annotate: configure objdump path at compile time
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The perf built to run on the host needs to use arm-eabi-objdump from
>> the toolchain so that it can analyse data recorded on Android. This
>> patch is targeting this scenario, not the previous one. In this case,
>> the CROSS_COMPILE option would be different than arm-eabi- so using
>> $(CROSS_COMPILE)objdump would be wrong. objdump should be overridden
>> when running make since there is no connection between the toolchain
>> used here and the path for objdump. I am always overriding objdump
>> when calling make, so I did not catch this.
>>
>> I think that I should change DEFAULT_OBJDUMP_PATH=objdump in the
>> Makefile to handle the first scenario. I'll also explain this in the
>> commit message so that it is more clear and make the same change for
>> the addr2line patch.
>>
>> What do you think?
>
> I think the right thing to do is finding a correct objdump at runtime in
> some way.  Why do you want to make it compile-time configurable?
>

The correct objdump path can be detected at runtime by setting the
toolchain path. But since the name is arm-eabi-objdump and not
objdump, it does not know to use it instead.

The only way (I can think of) to change objdump at runtime would be to
use the --objdump option for perf annotate (and provide a similar
option for addr2line). The problem with this approach is that the user
has to be aware that perf annotate uses the objdump tool and that he
has to use the cross-compiler version instead. Since the user will
have perf compiled for host as part of his Android tree, he will
expect it to work without these further changes from his part. The
path for objdump can be set in the Android Makefile at compile time so
that the user doesn't need to be aware of it.

If compiling directly from the kernel tree, the advantage is not that
obvious. The user would still have to specify the name for objdump in
the command line when running make. But I think this is still a better
user experience compared to having to set this every time when using
perf annotate.

Thanks,
Irina
