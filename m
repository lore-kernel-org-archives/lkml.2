Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab2EOObM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:31:12 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:56161 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab2EOObK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:31:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4FB268A9.5040007@cam.ac.uk>
Date: Tue, 15 May 2012 15:31:05 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Guenter Roeck <guenter.roeck@ericsson.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        "Tc, Jenny" <jenny.tc@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: Generic ADC support for hwmon
References: <1337092008-31263-1-git-send-email-jenny.tc@intel.com> <20120515121339.GA21600@ericsson.com> <4D68720C2E767A4AA6A8796D42C8EB59124E22@BGSMSX101.gar.corp.intel.com> <20120515134257.GA21933@ericsson.com> <4FB265C1.7060306@metafoo.de>
In-Reply-To: <4FB265C1.7060306@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/2012 3:18 PM, Lars-Peter Clausen wrote:
> On 05/15/2012 03:42 PM, Guenter Roeck wrote:
>> On Tue, May 15, 2012 at 08:42:57AM -0400, R, Durgadoss wrote:
>>> Hi Guenter,
>>>
>>> Thanks for a quick reply.
>>>
>>>> On Tue, May 15, 2012 at 10:26:48AM -0400, Jenny TC wrote:
>>>>> Currently drivers are using custom APIs to communicate with ADC driver.
>>>>> So it make sense to have generic APIs to commnicate with ADC drivers.
>>>>> This patch introduces generic APIs to communicate with ADC drivers.
>>>>>
>>>>> Signed-off-by: Jenny TC<jenny.tc@intel.com>
>>>>
>>>> Hi Jenny,
>>>>
>>>> Do you have a practical use case ?
>>>
>>> We have some platform specific component drivers, thermal drivers,
>>> battery drivers using this General purpose ADC in the platform.
>>> That's why we thought of doing something like this.
>>>
>>>>
>>>> Also, shouldn't those generic ADCs rather be supported through the IO
>>>> subsystem ?
>>>> After all, hwmon is all about hardware monitoring, not to provide generic ADC
>>>> access.
>>>
>>> In this case, can we try this in iio or mfd subsystem ?
>>> Kindly advise.
>>>
>> I meant iio (more specifically staging/iio/adc).
>>
>> I suspect it might make more sense to have a hwmon client, in parallel to the other
>> users/clients (battery control, thermal etc), if the values reported by the ADC reflect
>> information relevant for hardware monitoring.
>>
>
> So there is already an experimental IIO to hwmon bridge in
> drivers/staging/iio/, which you can use to expose a IIO ADC driver as an
> hwmon device.
Thanks Lars-Peter.  That bridge is currently limited to voltage reading 
but that's more because my test part didn't do anything else.
Trivial to add other bits and bobs as needed.  In the short term, the
interrupt driven side of things is still under review (so you are 
limited to polling devices - though this is typically fine for hwmon
etc).  I'll be submitting a patch to move the existing hwmon bridge 
driver into drivers/hwmon in the next cycle (after the IIO core is out 
of staging).

Longer term plans involve reducing the connection between the IIO
userspace front end and the backend to give cleaner support when
people don't want generic userspace interfaces.  This means making
absolutely everything under the sun available through generic in kernel
interfaces which will be 'interesting' for some more interesting devices...

Jonathan
