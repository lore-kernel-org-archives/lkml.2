Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab1LBClA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:41:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:51885 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab1LBCk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:40:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,281,1320652800"; 
   d="scan'208";a="97720151"
Message-ID: <4ED83AB8.3000000@linux.intel.com>
Date: Fri, 02 Dec 2011 10:40:56 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] ramoops: use pstore interface
References: <20111128200951.GA3492@www.outflux.net>	<4ED4647D.4060305@linux.intel.com> <CAGXu5j+kzXpAhCYELDBBeMDPg2XMHt8jWRjZf2xiPVSMfUhjzA@mail.gmail.com> <4ED75765.5020002@gmail.com>
In-Reply-To: <4ED75765.5020002@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/12/1 18:31, Marco Stornelli 写道:
> Il 29/11/2011 18:24, Kees Cook ha scritto:
>> On Mon, Nov 28, 2011 at 8:50 PM, Chen Gong<gong.chen@linux.intel.com> wrote:
>>> 于 2011/11/29 4:09, Kees Cook 写道:
>>>>
>>>> Instead of using /dev/mem directly, use the common pstore infrastructure
>>>> to handle Oops gathering and extraction.
>>>>
>>>> Signed-off-by: Kees Cook<keescook@chromium.org>
>>>> ---
>>>> This depends on the pstore changes waiting for -next in:
>>>>
>>>> http://git.kernel.org/?p=linux/kernel/git/aegl/linux.git;a=shortlog;h=refs/heads/next
>>>>
>>>> ---
>>>> Documentation/ramoops.txt | 8 +-
>>>> drivers/char/Kconfig | 1 +
>>>> drivers/char/ramoops.c | 206
>>>> ++++++++++++++++++++++++++++++++++-----------
>>>> 3 files changed, 160 insertions(+), 55 deletions(-)
>>>>
>>>> diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
>>>> index 8fb1ba7..a0b9d8e 100644
>>>> --- a/Documentation/ramoops.txt
>>>> +++ b/Documentation/ramoops.txt
>>>> @@ -3,7 +3,7 @@ Ramoops oops/panic logger
>>>>
>>>> Sergiu Iordache<sergiu@chromium.org>
>>>>
>>>> -Updated: 8 August 2011
>>>> +Updated: 17 November 2011
>>>>
>>>> 0. Introduction
>>>>
>>>> @@ -71,6 +71,6 @@ timestamp and a new line. The dump then continues with
>>>> the actual data.
>>>>
>>>> 4. Reading the data
>>>>
>>>> -The dump data can be read from memory (through /dev/mem or other means).
>>>> -Getting the module parameters, which are needed in order to parse the
>>>> data, can
>>>> -be done through /sys/module/ramoops/parameters/* .
>>>> +The dump data can be read from the pstore filesystem. The format for
>>>> these
>>>> +files is "dmesg-ramoops-N", where N is the record number in memory. To
>>>> delete
>>>> +a stored record from RAM, simply unlink the respective pstore file.
>>>
>>> I think the definition of "mem_address" in the doc is not very clear. It is
>>> not a normal memory instead of a persistent RAM. I suggest adding more
>>> descriptions.
>>> It's better if there is a real example.
>>
>> Okay. I'm not sure it's in the scope of this patch, but I can try.
>>
>> Marco, do you have suggestions for how this could be enhanced?
>>
>
> I don't know actually. It's not mandatory use a persistent memory. A simple
> piece of reserved RAM is ok. Obviously it will work only over reboot and not
> over power down. I define mem_address as a generic piece of reserved memory.
>
> Marco

Anyway, we need a pratical exmaple to instruct us how to use this diver.

