Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab2DDTlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:41:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36356 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab2DDTl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:41:29 -0400
Message-ID: <4F7CA3E1.2050809@ti.com>
Date: Wed, 4 Apr 2012 21:41:21 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Trilok Soni <tsoni@codeaurora.org>
CC: <jean.pihet@newoldbits.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Kevin Hilman <khilman@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 2/9] ARM: OMAP2+: SmartReflex: move the driver specific
 macros in include/linux/power
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com> <1332173578-27422-3-git-send-email-j-pihet@ti.com> <4F7C9C89.9080605@codeaurora.org>
In-Reply-To: <4F7C9C89.9080605@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/2012 9:10 PM, Trilok Soni wrote:
> Hi Jean,
>
> On 3/19/2012 9:42 PM, jean.pihet@newoldbits.com wrote:
>> From: Jean Pihet<j-pihet@ti.com>
>>
>> Move the driver specific macros from the smartreflex header file
>> (arch/arm/mach-omap2/smartreflex.h) in a new header file
>> include/linux/power/smartreflex.h.
>>
>> This change makes the SmartReflex implementation ready for the move
>> to drivers/.
>
> I wonder why someone would need a new directory under drivers/power
> where the code is not about introducing new and generic AVS framework
> but it is all about OMAP specific code.

The main motivation is that it's a driver and thus does not have 
anything to do inside mach-omap2.

Where will you put that otherwise?

> What if tomorrow new generic
> AVS framework comes from different chip vendor? I am sure this kind
> of technology would be common in newer embedded chips.

Probably, but this is hard to know with only one implementation so far 
in the kernel.
I guess when someone else will start pushing some new AVS driver inside 
the AVS directory, we might realize that there is enough common part to 
create a frwmk.

IIRC, David Brownell was referring to the rule of three for such case. 
Meaning that it worth having a generic fmwk when at least three 
different drivers are doing the same kind of things.

Regards,
Benoit
