Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2EOOPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:15:51 -0400
Received: from smtp-out-008.synserver.de ([212.40.185.8]:1074 "EHLO
	smtp-out-006.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753018Ab2EOOPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:15:50 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30374
Message-ID: <4FB265C1.7060306@metafoo.de>
Date: Tue, 15 May 2012 16:18:41 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: "R, Durgadoss" <durgadoss.r@intel.com>, "Tc, Jenny" <jenny.tc@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: Generic ADC support for hwmon
References: <1337092008-31263-1-git-send-email-jenny.tc@intel.com> <20120515121339.GA21600@ericsson.com> <4D68720C2E767A4AA6A8796D42C8EB59124E22@BGSMSX101.gar.corp.intel.com> <20120515134257.GA21933@ericsson.com>
In-Reply-To: <20120515134257.GA21933@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 03:42 PM, Guenter Roeck wrote:
> On Tue, May 15, 2012 at 08:42:57AM -0400, R, Durgadoss wrote:
>> Hi Guenter,
>>
>> Thanks for a quick reply.
>>
>>> On Tue, May 15, 2012 at 10:26:48AM -0400, Jenny TC wrote:
>>>> Currently drivers are using custom APIs to communicate with ADC driver.
>>>> So it make sense to have generic APIs to commnicate with ADC drivers.
>>>> This patch introduces generic APIs to communicate with ADC drivers.
>>>>
>>>> Signed-off-by: Jenny TC <jenny.tc@intel.com>
>>>
>>> Hi Jenny,
>>>
>>> Do you have a practical use case ?
>>
>> We have some platform specific component drivers, thermal drivers,
>> battery drivers using this General purpose ADC in the platform.
>> That's why we thought of doing something like this.
>>
>>>
>>> Also, shouldn't those generic ADCs rather be supported through the IO
>>> subsystem ?
>>> After all, hwmon is all about hardware monitoring, not to provide generic ADC
>>> access.
>>
>> In this case, can we try this in iio or mfd subsystem ?
>> Kindly advise.
>>
> I meant iio (more specifically staging/iio/adc).
> 
> I suspect it might make more sense to have a hwmon client, in parallel to the other
> users/clients (battery control, thermal etc), if the values reported by the ADC reflect
> information relevant for hardware monitoring.
> 

So there is already an experimental IIO to hwmon bridge in
drivers/staging/iio/, which you can use to expose a IIO ADC driver as an
hwmon device.

Add Jonathan to Cc.

- Lars
