Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2G3BuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:50:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2665 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab2G3Bt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:49:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 29 Jul 2012 18:49:49 -0700
Message-ID: <5015E8AE.8060404@nvidia.com>
Date: Mon, 30 Jul 2012 10:51:42 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <1343390750-3642-2-git-send-email-acourbot@nvidia.com> <20120727181923.GB23564@kroah.com>
In-Reply-To: <20120727181923.GB23564@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2012 03:19 AM, Greg Kroah-Hartman wrote:
> On Fri, Jul 27, 2012 at 09:05:48PM +0900, Alexandre Courbot wrote:
>> Some device drivers (panel backlights especially) need to follow precise
>> sequences for powering on and off, involving gpios, regulators, PWMs
>> with a precise powering order and delays to respect between each steps.
>> These sequences are board-specific, and do not belong to a particular
>> driver - therefore they have been performed by board-specific hook
>> functions to far.
>>
>> With the advent of the device tree and of ARM kernels that are not
>> board-tied, we cannot rely on these board-specific hooks anymore but
>> need a way to implement these sequences in a portable manner. This patch
>> introduces a simple interpreter that can execute such power sequences
>> encoded either as platform data or within the device tree.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>   Documentation/power/power_seq.txt | 120 +++++++++++++++
>>   drivers/base/Kconfig              |   4 +
>>   drivers/base/Makefile             |   1 +
>>   drivers/base/power_seq.c          | 300 ++++++++++++++++++++++++++++++++++++++
>>   include/linux/power_seq.h         | 139 ++++++++++++++++++
>
> What's wrong with drivers/power/?  I sure don't want to maintain this
> code, and it seems to not be part of the "driver core" infrastructure.

I thought about drivers/power/ initially, but quickly realized it was 
only about the power supply class and its drivers - so I felt like it 
would be out of place there, as the power sequences have nothing to do 
with power supply but instead control gpios, regulators and pwms.

On the other hand I have just noticed that the apparently unrelated 
Adaptive Voltage Scaling driver just appeared in drivers/power/avs. So 
if Anton and David are ok with this, maybe I could put the power 
sequences code in its own subdirectory within drivers/power.

Thanks,
Alex.

