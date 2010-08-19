Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab0HSBEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 21:04:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:31153 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0HSBEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 21:04:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VLAdZZK45n9B52hrFXYQXWffFTEjbKyO0UscZGvSp5/e5cUv85IKeLrcGrVP6v3N/
	GZYFIrRCDZn4IiC/VUjqQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTimqzQHtSo5f41ze4JEznGCjMNTC_1DPgc21JYT0@mail.gmail.com>
References: <20100818151857.GA6188@barrios-desktop>
	<20100818172627.7e38969f@varda>
	<AANLkTimxbJQ7+cJ20x1Bcm=1xk_JgMANUQDFn-pJ9jZa@mail.gmail.com>
	<AANLkTimqzQHtSo5f41ze4JEznGCjMNTC_1DPgc21JYT0@mail.gmail.com>
Date: Wed, 18 Aug 2010 18:04:03 -0700
Message-ID: <AANLkTinjKK_jKm04BNmTRwq5uW8ainDcJHOXCGCmOXuD@mail.gmail.com>
Subject: Re: android-kernel memory reclaim x20 boost?
From: San Mehat <san@google.com>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
        swetland@google.com, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 6:01 PM, Arve Hjønnevåg <arve@android.com> wrote:
> On Wed, Aug 18, 2010 at 5:54 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> On Thu, Aug 19, 2010 at 12:26 AM, Alejandro Riveira Fernández
>> <ariveira@gmail.com> wrote:
>>> El Thu, 19 Aug 2010 00:18:57 +0900
>>> Minchan Kim <minchan.kim@gmail.com> escribió:
>>>
>>>> Hello Android forks,
>>> [ ... ]
>>>>
>>>> I saw the advertisement phrase in this[1].
>>>>
>>>> "Kernel Memory Management Boost: Improved memory reclaim by up to 20x,
>>>> which results in faster app switching and smoother performance
>>>> on memory-constrained devices."
>>>>
>>>> But I can't find any code for it in android kernel git tree.
>>>
>>>  Maybe the enhancements are on the Dalvik VM (shooting in the dark here)
>>
>> Thanks.
>> Android guys! Could you confirm this?
>>
>
> It is more likely referring to this change:
>

There are other changes after the one mentioned that remove the
requirement for CONFIG_PROFILING
(and the subsequent task_struct leak that was caused by it)

-san

> Author: San Mehat <san@google.com>
> Date:   Wed May 5 11:38:42 2010 -0700
>
>    staging: android: lowmemkiller: Substantially reduce overhead during reclaim
>
>    This patch optimizes lowmemkiller to not do any work when it has
> an outstanding
>    kill-request. This greatly reduces the pressure on the task_list lock
>    (improving interactivity), as well as improving the vmscan performance
>    when under heavy memory pressure (by up to 20x in tests).
>
>    Note: For this enhancement to work, you need CONFIG_PROFILING
>
>    Signed-off-by: San Mehat <san@google.com>
>
>
> --
> Arve Hjønnevåg
>



-- 
San Mehat  |  Staff Software Engineer  |  Infrastructure  |  Google Inc.
415.366.6172 (san@google.com)
