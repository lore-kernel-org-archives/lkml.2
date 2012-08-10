Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab2HJOSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:18:24 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3591 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2HJOSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:18:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 10 Aug 2012 07:18:21 -0700
Message-ID: <50251826.9020303@nvidia.com>
Date: Fri, 10 Aug 2012 19:48:14 +0530
From: Bitan Biswas <bbiswas@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: <khali@linux-fr.org>, <guenter.roeck@ericsson.com>,
        <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: hwmon : raw reading -> temperature conversion
Content-Type: text/plain; charset="iso-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question related to hwmon driver and need suggestions.

I am working on a temperature sensor driver that is hwmon driver.
- The temperature is calculated from raw sensor reading and
certain initialization parameters.
- Raw reading obtained from 2 different sensor instances under
same conditions can differ. Further, initialization parameters
are specific to each hardware instance.
- Expressions with floating point operands are used to compute
the temperature value.

In our platform there are multiple kernel level clients to the
temperature sensor driver.
Hence I am planning to present temperature to these clients
from kernel driver itself.

But looking at the hwmon linux documentation, seems the sensor
kernel drivers should report only raw readings.
The raw readings can be converted into required output,
e.g. temperature in this case, by respective user space implementation.

However because of my driver clients being in kernel space, I am
thinking of doing fixed point calculations in the sensor driver
and get the temperature corresponding to raw sensor readings.

Please let me know if this a correct approach?

If there is a better way, please suggest.

-regards,
Bitan


