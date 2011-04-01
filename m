Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab1DALFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:05:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52425 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab1DALFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VGXYdSs3qzb0r0I/au9UI9kR5fiyFQSKmeohAJKZTIkiaAJnNAAKFBEdv7iCibCiyb
         LNkUr3rJttSySDmi0QNPJ+4rA53/hjUxnaZ/0ie0Whge5aFUKfHHE+CF1FsL4xp8zOr8
         W/dujpuGSw61JB9Lt3tBptrJT3019aevYkzA0=
Message-ID: <4D95B160.5020605@gmail.com>
Date: Fri, 01 Apr 2011 15:05:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] [PATCH] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
References: <4D94EF4B.6070905@gmail.com> <1301655194.4859.479.camel@twins>
In-Reply-To: <1301655194.4859.479.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 02:53 PM, Peter Zijlstra wrote:
> On Fri, 2011-04-01 at 01:16 +0400, Cyrill Gorcunov wrote:
>> Because of Netburst HW restriction we can't move events arbitrary
>> between counters and this makes 'perf top' unable to run if nmi-watchdog
>> is running (since both uses PERF_COUNT_HW_CPU_CYCLES but such event is
>> bound to run on a few counters only). So as a workaround we could count that named
>> non-sleeping ticks (as oprofile does) and both perf top and nmi-watchdog would co-exsist
>> without conflicts but kernel needs to know about such specifics -- so PERF_COUNT_HW_NMI_WATCHDOG
>> event is introduced. This event is an alias of PERF_COUNT_HW_CPU_CYCLES for non-P4 x86
>> architecture so nothing much changed I think.
>>
>> Please review, I might be missing something. Also comments on idea is quite welcome since
>> it touches ABI part.
> 
> 
>>  arch/x86/kernel/cpu/perf_event_amd.c   |    1 +
>>  arch/x86/kernel/cpu/perf_event_intel.c |    1 +
>>  arch/x86/kernel/cpu/perf_event_p4.c    |   15 +++++++++++++++
>>  arch/x86/kernel/cpu/perf_event_p6.c    |    1 +
>>  include/linux/perf_event.h             |    1 +
>>  kernel/watchdog.c                      |    2 +-
>>  6 files changed, 20 insertions(+), 1 deletions(-)
> 
> is x86 the only arch using the watchdog things?

Hm, good question. The powerpc, sparc, sh, arm, mips have PERF_COUNT_HW_CPU_CYCLES.
Seems I've missed those archs. Thanks Peter, will take a look.

-- 
    Cyrill
