Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab2IFSUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:20:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55344 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2IFST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:19:59 -0400
Message-ID: <5048E94A.2020303@gmail.com>
Date: Thu, 06 Sep 2012 12:19:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
References: <20120723181358.GC6717@infradead.org> <500EAF23.8060909@gmail.com> <20120724161507.GG3732@erda.amd.com> <500EDB50.3070704@gmail.com> <20120724180312.GJ6717@infradead.org> <5010D2B1.3000206@gmail.com> <1343290109.26034.82.camel@twins> <20120803135117.GC3732@erda.amd.com> <50477332.1000902@gmail.com> <1346882872.2600.63.camel@twins> <20120906174452.GC8285@erda.amd.com>
In-Reply-To: <20120906174452.GC8285@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/12 11:44 AM, Robert Richter wrote:
> David,
>
> On 06.09.12 00:07:52, Peter Zijlstra wrote:
>> On Wed, 2012-09-05 at 09:43 -0600, David Ahern wrote:
>>> We need to require exclude_guest when using precise attribute with perf
>>> else all running VMs on Intel-based servers will crash. I do not have an
>>> AMD based server to even attempt the preferred solution.
>
> do you have a perf tool patch ready that enables exclude_guest per
> default for precise events? I have ibs kernel code that returns EINVAL
> in this case.  Current perf tool should then fall back by sending
> another syscall with the exclude_guest modifier disabled. This should
> work for ibs. Testing your patch wouln't be an effort for me.

The beginning of this thread:
     https://lkml.org/lkml/2012/7/20/437

Takes the route of setting exclude_guest if precise is specified. This 
is simpler than adding yet another failure detect with fallback.


>
> To prevent Intel-based servers from crashing, pebs should be only
> enabled if the exclude_guest modifier is enabled. I guess there is
> already kernel code to prevent this, but didn't look at the sources.

Peter's patch takes care of this, but it can't be applied until 
userspace code is updated to avoid userspace breakage. And the userspace 
patch can't be applied until AMD side handles the exclude_guest setting.

>
> To prevent probing the kernel with syscalls to detect pmu features, I
> suggested some time ago to introduce
>
>   /sys/bus/event_source/devices/*/flags
>
> or so similar to /proc/cpuinfo:flags. Any opinions on that?

I think that is up to Peter, Ingo, Arnaldo.

David

>
> There is also the option to emulate exclude_guest for ibs in
> software. So far I didn't have the time to look at this. We could
> still add this in the future. Since we need to fix current mainline
> anyway where such a patch wouldn't go in for v3.6, I will send my
> current ibs kernel fixes I mentioned above next days. It would be
> great to test this also with your patch.
>
> Thanks,
>
> -Robert
>

