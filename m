Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2JWLEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 07:04:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:49414 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab2JWLEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 07:04:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,634,1344236400"; 
   d="scan'208";a="159311571"
Message-ID: <50867A2B.5020606@linux.intel.com>
Date: Tue, 23 Oct 2012 14:06:19 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] gpiolib: add gpio get direction support
References: <1350913454-26927-1-git-send-email-mathias.nyman@linux.intel.com> <CACRpkdbxfL+1NQ73ve8Hz4VKaVMzJS-P7H50kSNVODAU9mm7QA@mail.gmail.com>
In-Reply-To: <CACRpkdbxfL+1NQ73ve8Hz4VKaVMzJS-P7H50kSNVODAU9mm7QA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 01:23 AM, Linus Walleij wrote:
> On Mon, Oct 22, 2012 at 3:44 PM, Mathias Nyman
> <mathias.nyman@linux.intel.com>  wrote:
>
>> If the .get_direction callback is set, then gpiolib will use it
>> for showing correct gpio direction in sysfs and debug. If not set
>> then it will work the old way; e.g. guessing everything is input
>> until direction is set.
>
> If the driver cannot report the direction setting you *could*
> cache the result of all calls to gpio_direction_output()
> and gpio_direction_input() somewhere. But I don't know
> if it's a good idea.
>
> Anyway, if the callback is only called internally in the GPIOlib
> why are you making the function public to the entire
> kernel

Thought I'd do it the same was as gpio_direction_output() and 
gpio_direction_input(), but if there is no need for getting the 
direction outside gpiolob then it can be skipped. Main motivation was to 
get correct direction values in debug and sysfs after boot.

gpiolib currently uses cached values of gpio_direction_output/input() in 
sysfs. If the .get_direction callback exists it is used to refresh the 
cached values.

I'll write a new patch without the public gpio_get_direction().

-Mathias
