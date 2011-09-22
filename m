Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab1IVPsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:48:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54541 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1IVPsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:48:40 -0400
Message-ID: <4E7B58D3.5060006@gmail.com>
Date: Thu, 22 Sep 2011 09:48:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, Anton Blanchard <anton@samba.org>
CC: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, robert.richter@amd.com, ak@linux.intel.com
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
References: <20110922123128.GA9761@quad> <4E7B55BC.5050303@gmail.com> <CABPqkBSBXenw7AFg-HZY+j0kVAk+cu53S_dF3_GKD8VUGf9UYQ@mail.gmail.com>
In-Reply-To: <CABPqkBSBXenw7AFg-HZY+j0kVAk+cu53S_dF3_GKD8VUGf9UYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2011 09:40 AM, Stephane Eranian wrote:
>>> diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
>>> new file mode 100644
>>> index 0000000..d4bf958
>>> --- /dev/null
>>> +++ b/tools/perf/arch/powerpc/util/header.c
>>> @@ -0,0 +1,36 @@
>>> +#include <sys/types.h>
>>> +#include <unistd.h>
>>> +#include <stdio.h>
>>> +#include <stdlib.h>
>>> +#include <string.h>
>>> +
>>> +#include "../../util/header.h"
>>> +
>>> +static inline unsigned long mfspr(int rn)
>>> +{
>>> +     unsigned long rval;
>>> +     asm volatile("mfspr %0," __stringify(rn) : "=r" (rval));
>>> +     return  rval;
>>> +}
>>
>> Fails to compile on powerpc:
>>
>> arch/powerpc/util/header.c: In function ‘mfspr’:
>> arch/powerpc/util/header.c:12: error: expected ‘:’ or ‘)’ before
>> ‘__stringify’
>> cc1: warnings being treated as errors
>> arch/powerpc/util/header.c:9: error: unused parameter ‘rn’
>> make: *** [/tmp/stephane/arch/powerpc/util/header.o] Error 1
>> make: *** Waiting for unfinished jobs....
>>
> 
> Argh, I don't have a PPC system, so I made this up (based on libpfm4 code).
> 
> Does adding:
> 
> #define __stringify_1(x)        #x
> #define __stringify(x)          __stringify_1(x)
> 
> Solve the problem?

No. I added those lines above mfspr(). Now the error is:
cc1: warnings being treated as errors
arch/powerpc/util/header.c: In function ‘mfspr’:
arch/powerpc/util/header.c:11: error: unused parameter ‘rn’
make: *** [/tmp/stephane/arch/powerpc/util/header.o] Error 1
make: *** Waiting for unfinished jobs....

which does seem logical given that rn is used in stringify.

Maybe Anton can help with this (cc'ed).

David
