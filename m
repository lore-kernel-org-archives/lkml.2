Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0LPJvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:51:12 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36018 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0LPJvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:51:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=fR6spGkfiZkXXNWJjNKpAT5+9W3t7p+144XGtgpNjApqEp4zPhFqnfl0Yv2oehkpDh
         oOIhnPzlHqYGwHtdNxWqDYWOMn1sq8H3l5GL3rNExisw1H1nfsoQ9KM2H/EN6qf9oEYv
         /KhxFC3ky+BtZl//+4oa76bHHAoVglSg7TmVM=
Message-ID: <4D09E0EE.7040605@gmail.com>
Date: Thu, 16 Dec 2010 10:50:38 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
References: <1291255347.12777.116.camel@sli10-conroe> <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe> <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe> <4D073FA9.9020801@gmail.com> <1292378268.2323.464.camel@sli10-conroe> <4D08CBF4.6040102@gmail.com> <1292460817.2323.465.camel@sli10-conroe> <20101216054620.GA3241@merkur.ravnborg.org> <1292479000.2323.468.camel@sli10-conroe>
In-Reply-To: <1292479000.2323.468.camel@sli10-conroe>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

On 12/16/2010 06:56 AM, Shaohua Li wrote:
>>>>> -#include <asm-generic/vmlinux.lds.h>
>>>>>  #include <asm/asm-offsets.h>
>>>>>  #include <asm/thread_info.h>
>>>>>  #include <asm/page_types.h>
>>>>>  #include <asm/cache.h>
>>>>> +#include <asm-generic/vmlinux.lds.h>
>>>>>  #include <asm/boot.h>
>>>>
>>>> Why do we need this chunk?
>>> the cache size is defined in cache.h, so I need move vmlinux.lds.h after
>>> cache.h
>>
>> The right fix is to move the inclusion of cache.h to
>> asm-generic/vmlinux.lds.h.  A quick audit only found sparc that
>> failed to guard non assembler stuff.
>
> with this, we need check every arch, at least doing a compile. I'm
> afraid I can't, sorry.

Not being able to cross build every arch is okay but you at least need
to make an effort to make things easily applicable to other archs and
avoid adding subtle ugliness like the above.  Please at least try to
look at other arch codes and see how things can be made to work across
different archs.  Setting up cross compilers for the major archs, for
example, sparc, power and ia64 isn't that difficult either.

Thanks.

-- 
tejun
