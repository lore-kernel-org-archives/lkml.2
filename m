Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab2GYNlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:41:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917Ab2GYNlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:41:08 -0400
Message-ID: <500FF767.8020507@redhat.com>
Date: Wed, 25 Jul 2012 16:40:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: x86/mm: Limit 2/4M size calculation to x86_32
References: <5000259D.9020303@canonical.com> <CAM_iQpVPzB69R1_4E_J5Yw=d1TncqHe0+dWEwOufQniNcpBVtg@mail.gmail.com> <500FCDF3.7080808@redhat.com> <500FD4FA.7020904@canonical.com> <500FE74C.4040907@redhat.com> <500FF3A1.6080809@canonical.com>
In-Reply-To: <500FF3A1.6080809@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 04:24 PM, Stefan Bader wrote:
>>> ...
>>> ifdef CONFIG_X86_32
>>>         /*
>>>          * Don't use a large page for the first 2/4MB of memory
>>>          * because there are often fixed size MTRRs in there
>>>          * and overlapping MTRRs into large pages can cause
>>>          * slowdowns.
>>>          */
>>>
>> 
>> That's equally true for X86_64.
>> 
>> Best would be to merge the MTRRs into PAT, but that might not work for SMM.
>> 
>> 
> Ok, true. Not sure why this was restricted to 32bit when reconsidering. Except
> if in 64bit it was assumed (or asserted) that the regions are aligned to 2M...
> But maybe this can be answered by someone knowing the details. I would not mind
> either way (have the first range with 4K pages in all cases or fixing the
> additional PTE allocation). Just as it is now it is inconsistent.

Sometimes CONFIG_X86_32 is used as an alias for "machines so old they
don't support x86_64".  As a 32-bit kernel can be run on a machine that
does support x86_64, it should be replaced by a runtime test for
X86_FEATURE_LM, until a more accurate test can be found.

-- 
error compiling committee.c: too many arguments to function


