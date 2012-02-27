Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2B0SAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:00:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54542 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2B0SAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:00:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dsahern@gmail.com designates 10.68.73.225 as permitted sender) smtp.mail=dsahern@gmail.com; dkim=pass header.i=dsahern@gmail.com
Message-ID: <4F4BC4A4.10006@gmail.com>
Date: Mon, 27 Feb 2012 11:00:04 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        peterz@infradead.org, mingo@elte.hu, joro@8bytes.org, gleb@redhat.com,
        joerg.roedel@amd.com
Subject: Re: [PATCH] perf tools: fix guest mode monitoring on AMD
References: <20120227173351.GA6945@quad> <4F4BC1AD.9030600@gmail.com> <CABPqkBRUzp-gBANhiMerHanN7yaTnJbxHNEjz_mw+XRYT8ZHUw@mail.gmail.com>
In-Reply-To: <CABPqkBRUzp-gBANhiMerHanN7yaTnJbxHNEjz_mw+XRYT8ZHUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/12 10:52 AM, Stephane Eranian wrote:
> On Mon, Feb 27, 2012 at 6:47 PM, David Ahern<dsahern@gmail.com>  wrote:
>> On 2/27/12 10:33 AM, Stephane Eranian wrote:
>>>
>>> Commit:
>>>
>>> 1aed267 perf kvm: Do guest-only counting by default
>>>
>>> introduced a bug on AMD systems whereby simple commands:
>>>
>>> $ perf stat ls
>>> Performance counter stats for 'ls':
>>>                   0 cycles                    #    0.000 GHz
>>>         0.003704596 seconds time elapsed
>>>
>>> would not count anything anymore. Same results for perf record.
>>>
>>> I tracked it down to guest mode exclusion being enabled
>>> by default leading to attr->exclude_guest = 1. When
>>> not operating under any sort of virtualization, this
>>> causes the PMU not to count anything.
>>>
>>> The fix disables guest exclusion by default.
>>>
>>> Signed-off-by: Stephane Eranian<eranian@google.com>
>>> ---
>>>
>>> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
>>> index 8109a90..c1017b3 100644
>>> --- a/tools/perf/util/util.c
>>> +++ b/tools/perf/util/util.c
>>> @@ -6,7 +6,7 @@
>>>    * XXX We need to find a better place for these things...
>>>    */
>>>   bool perf_host  = true;
>>> -bool perf_guest = false;
>>> +bool perf_guest = true;
>>
>>
>> This was recently reverted to false by
>> c4a7dca92bbb9881a5d678720f1d0c2153499749
>>
>> See: https://lkml.org/lkml/2012/2/8/234
>>
> Yeah, but that causes simple commands such as "perf stat -e cycles ls"
> to return 0 count.
>
> So either you get a segfault or you get zero count. There is something
> else going on here...

agreed. Did you try reverting exclude_guest by default?

