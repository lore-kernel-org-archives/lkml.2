Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2KEMLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:11:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:16804 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab2KEMLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:11:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,714,1344236400"; 
   d="scan'208";a="164599125"
Message-ID: <5097AD9D.7060808@linux.intel.com>
Date: Mon, 05 Nov 2012 14:14:21 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <1351928793-14375-2-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdYGbNCzV7QOURcEzhrNWv=kbWq+r3i66GtC75Aytso5rw@mail.gmail.com>
In-Reply-To: <CACRpkdYGbNCzV7QOURcEzhrNWv=kbWq+r3i66GtC75Aytso5rw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 01:53 PM, Linus Walleij wrote:
> On Sat, Nov 3, 2012 at 8:46 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com>  wrote:
>
>> +/**
>> + * acpi_get_gpio() - Translate ACPI GPIO pin to GPIO number usable with GPIO API
>> + * @path:      ACPI GPIO controller full path name, (e.g. "\\_SB.GPO1")
>> + * @pin:       ACPI GPIO pin number (0-based, controller-relative)
>> + *
>> + * Returns GPIO number to use with Linux generic GPIO API, or errno error value
>> + */
>
> So by just looking at that we can see that this is yet another
> instance of papering
> over the fact that the Linux GPIO numbers are global to the kernel and not
> per-chip, as would be preferred.

Yes, it is. ACPI5 GPIO resources are numbered per-chip. This is just a 
way for device drivers to find the corresponding Linux GPIO.

per-chip based numbering sounds saner, but this deals with what we 
currently have.

>
> Can you please contribute to the parallel discussion on how to get rid of
> the global GPIO numberspace, thread named:
> "How about a gpio_get(device *, char *) function?"

I'll take a look at it, (and see if I got anything of value to add)

-Mathias
