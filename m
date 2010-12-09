Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0LIRGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:06:51 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:34615 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0LIRGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:06:50 -0500
Message-ID: <4D010C9D.6020005@linux.vnet.ibm.com>
Date: Thu, 09 Dec 2010 09:06:37 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: jovi zhang <bookjovi@gmail.com>
CC: Thiago Farina <tfransosi@gmail.com>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_event: fix error handling path
References: <1291432752-2466-1-git-send-email-bookjovi@gmail.com> <AANLkTimnSPSEx+B+wgxJaaAO8-HxcnLW+Nob4O3mjxBn@mail.gmail.com> <AANLkTimFjH6JZjOhPBrHmfpRycs4gDJuCpa+koxEyNgY@mail.gmail.com> <AANLkTi=HGdGs++FKY6=icEs3FTwSggXTu42JQ+1MCxBc@mail.gmail.com>
In-Reply-To: <AANLkTi=HGdGs++FKY6=icEs3FTwSggXTu42JQ+1MCxBc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 05:51 PM, jovi zhang wrote:
> On Mon, Dec 6, 2010 at 9:59 AM, jovi zhang<bookjovi@gmail.com>  wrote:
>> On Sun, Dec 5, 2010 at 8:29 PM, Thiago Farina<tfransosi@gmail.com>  wrote:
>>>
>>> On Sat, Dec 4, 2010 at 1:19 AM,<bookjovi@gmail.com>  wrote:
>>>> fix error handling path
>>>>
>>>> Signed-off-by: Jovi Zhang<bookjovi@gmail.com>
>>>>   kernel/perf_event.c |    2 --
>>>>   1 files changed, 0 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>>>> index cb6c0d2..62f9e9d 100644
>>>> --- a/kernel/perf_event.c
>>>> +++ b/kernel/perf_event.c
>>>> @@ -1918,8 +1918,6 @@ static int get_callchain_buffers(void)
>>>>         }
>>>>
>>>>         err = alloc_callchain_buffers();
>>>> -       if (err)
>>>> -               release_callchain_buffers();
>>>
>>> Care to explain in the change log message? As I reader, is not clear
>>> to me what is wrong with this.
>>
>> Sorry, the description should be as:
>> fix error handling path. alloc_callchain_buffers() can return -ENOMEM,
>> in this time callchain_cpus_entries maybe is NULL, It will oops if
>> invoke release_callchain_buffers() when callchain_cpus_entries is
>> NULL.
>>
> I hope my understanding is right, is it?

One possible problem here is what if it returns an error other than 
-ENOMEM, and the buffers do need to be released?  Maybe you could change 
the code to

err = alloc_callchain_buffers();
if (err != -ENOMEM)
	release_callchain_buffers();


Currently, alloc_callchain_buffers cannot return any error code other 
than -ENOMEM, but that might change in the future.

- Corey
