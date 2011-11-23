Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1KWQqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:46:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63331 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1KWQqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:46:39 -0500
Message-ID: <4ECD21F9.1010300@gmail.com>
Date: Wed, 23 Nov 2011 17:40:25 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 2/2] ramoops: remove module parameters
References: <1321644698-13677-1-git-send-email-keescook@chromium.org>	<1321644698-13677-3-git-send-email-keescook@chromium.org>	<4EC77605.5090605@gmail.com>	<CAGXu5j+Dh2jbAymcreOwX_T6=7FA8bOuwUFnwshdsVonAD5_EA@mail.gmail.com>	<4ECBDA7A.80504@gmail.com> <CAGXu5jKHaP4GsuSh9P=+3QJEWhaAy1F_RghuQJdSzmfh0wNAiQ@mail.gmail.com>
In-Reply-To: <CAGXu5jKHaP4GsuSh9P=+3QJEWhaAy1F_RghuQJdSzmfh0wNAiQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/11/2011 19:14, Kees Cook ha scritto:
> On Tue, Nov 22, 2011 at 9:23 AM, Marco Stornelli
> <marco.stornelli@gmail.com>  wrote:
>> Il 21/11/2011 19:11, Kees Cook ha scritto:
>>>
>>> On Sat, Nov 19, 2011 at 1:25 AM, Marco Stornelli
>>> <marco.stornelli@gmail.com>    wrote:
>>>>
>>>> Il 18/11/2011 20:31, Kees Cook ha scritto:
>>>>>
>>>>> The ramoops driver is intended to be used with platforms that define
>>>>> persistent memory regions. If memory regions were configurable with
>>>>> module parameters, it would be possible to read some RAM regions via
>>>>> the pstore interface without access to /dev/mem (which would result
>>>>> in a loss of kernel memory privacy when a system is built with
>>>>> STRICT_DEVMEM), so remove this ability completely.
>>>>>
>>>>
>>>> I don't like it very much. The loss of module parameters give us less
>>>> flexibility. The main goal of this driver is debug, so I think it should
>>>> be
>>>> fast to use. I mean it's not more possible reserve a memory region and
>>>> load
>>>> the module "on-the-fly", it needs a platform device, it's ok but I think
>>>> it's a little bit more complicated, (without talking about platforms
>>>> without
>>>> a device tree source).
>>>> I don't understand the problem of strict devmem. We shouldn't use kernel
>>>> memory region but only reserved ones and the driver doesn't use the
>>>> request_mem_region_exclusive, am I wrong?
>>>
>>> Hmmm, maybe I'm reading it backwards, but I think we want it to use
>>> ..._exclusive().
>>>
>>> int devmem_is_allowed(unsigned long pagenr)
>>> {
>>>          if (pagenr<= 256)
>>>                  return 1;
>>>          if (iomem_is_exclusive(pagenr<<    PAGE_SHIFT))
>>>                  return 0;
>>>          if (!page_is_ram(pagenr))
>>>                  return 1;
>>>          return 0;
>>> }
>>>
>>> If the region is exclusive, access is not allowed (return 0). ramoops
>>> currently uses request_mem_region() instead of
>>> request_mem_region_exclusive(). If we made that switch, I think I'd be
>>> happy. Would this create some problem I'm not seeing?
>>
>> I don't understand why we should use the exclusive version, to protect debug
>> data? You should provide a more valid reason to change, because the fact you
>> will be happier with this change is not enough for me :)
>
> I guess ..._exclusive() doesn't matter. My concern was that ramoops
> with the pstore interface and the module parameters could be used to
> bypass STRICT_DEVMEM if it were able to be loaded in some sensitive
> region of system memory. Perhaps the better approach would be to use a
> magic header so that uninitialized memory isn't visible? What do you
> think?
>
> -Kees
>

Sincerely, IMHO, if we consider the *debug* nature of this driver, it's 
sufficient a simple script (distributed with the kernel) to extract the 
all the information you need without touch the current implementation.

Marco
