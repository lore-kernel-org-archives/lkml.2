Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761Ab2CVVud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:50:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:10302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab2CVVub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:50:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="120654582"
Message-ID: <4F6B9E7B.9090005@linux.intel.com>
Date: Thu, 22 Mar 2012 14:49:47 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Michael Brunner <mibru@gmx.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] pch_uart: Add Kontron COMe-mTT10 uart clock quirk
References: <20120322211903.6776ab18@mail.gmx.de> <4F6B8E1B.9080802@linux.intel.com> <20120322223112.291e0c59@mail.gmx.de>
In-Reply-To: <20120322223112.291e0c59@mail.gmx.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/22/2012 02:31 PM, Michael Brunner wrote:
>> These boards should already be supported by the following BIOS check.
>> As the DMI_BOARD_NAME was changing, it was Kontron's recommendation
>> to use the FRI2 prefix in the DMI_BIOS_VERSION.
>>
>>
>>>  	cmp = dmi_get_system_info(DMI_BIOS_VERSION);
>>>  	if (cmp && strnstr(cmp, "FRI2", 4))
>>
>> Is this not working for you? If not, what is the DMI_BIOS_VERSION
>> reported by your board?
>>
>> And for clarification, we are talking about this right:
>> http://us.kontron.com/products/systems+and+platforms/m2m/m2m+smart+services+developer+kit.html
> 
> My changes refer to the embedded module with the project code NTC1:
> <http://us.kontron.com/products/computeronmodules/com+express/com+express+mini/comemtt10.html>
> 
> So unfortunately the FRI2 checks won't work for this.
> 
> Michael

OK, my board has DMI_BOARD_NAME as:

"nETXe-TT 1.0GHz E2 KDMS-FRI" but will also undergo a rename in the near
future. I'm concerned about colliding as I believe this kit may use the
same board you are working with. This COM Express module will be renamed
"COMe-mTT10" which will match your strstr compare.

So what does your DMI_BIOS_VERSION report?

I didn't like basing this on BIOS_VERSION, but I did so at Kontron's
preference. Now we're seeing the fallout (sooner than I expected).

So the question is, do we treat these as separate devices (the board and
the development kit which I believe includes your board) or do we lump
them together.

Since it is the firmware that ultimately decides what the initial
UARTCLK is, we can't base this on the hardware alone. The hardware in
fact should be default if a firmware match isn't found first. So, my
preference would be that you move your new comparison AFTER the FRI2
DMI_BIOS_VERSION comparison. This ensures the FRI2 doesn't match your
new comparison which might get a different UARTCLK in the future for
whatever reason.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
