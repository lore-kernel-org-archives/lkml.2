Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2EXH6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:58:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61761 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2EXH6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <1337845936.9783.57.camel@laptop>
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
	<1337844471.9783.48.camel@laptop>
	<CABPqkBRcz1a738M7g484B0p-dJrKqP6GSLE7gpPN0H1w-72oWw@mail.gmail.com>
	<1337845936.9783.57.camel@laptop>
Date: Thu, 24 May 2012 09:58:14 +0200
Message-ID: <CABPqkBSwpUHYcq89K-DYwa-6+hV2zNN5t2_22VHV4ROVUWsoGA@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 9:52 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-05-24 at 09:41 +0200, Stephane Eranian wrote:
>> So should we mark that
>> > as bad as well?
>> >
>> I never could but was told it was there too.
>>
>> > Also, do you happen to know if/when a u-code update would appear?
>> >
>> I am hoping Intel will release the ucode update very soon now. I will
>> post a patch
>> to re-enable PEBS on model 42 when that happens.
>
> OK, so how about I queue the below and if the u-code updates gets
> released before this hits Linus' tree we'll make it all go away ;-)
>
Let me get confirmation from Intel today before we do this.

> ---
> Subject: perf,x86: Mark PEBS as broken on SNB-EP as well
>
> As per information from Intel.
>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 166546e..6c8e400 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1840,8 +1840,8 @@ __init int intel_pmu_init(void)
>                break;
>
>        case 42: /* SandyBridge */
> -               x86_add_quirk(intel_sandybridge_quirk);
>        case 45: /* SandyBridge, "Romely-EP" */
> +               x86_add_quirk(intel_sandybridge_quirk);
>                memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
>                       sizeof(hw_cache_event_ids));
>
>
>
