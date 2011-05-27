Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1E0Q37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:29:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62842 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1E0Q35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:29:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6358"; a="94115933"
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Move Qualcomm gpio drivers into drivers dir
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
	<20110527031319.GH5032@ponder.secretlab.ca>
Date: Fri, 27 May 2011 09:29:56 -0700
In-Reply-To: <20110527031319.GH5032@ponder.secretlab.ca> (Grant Likely's
	message of "Thu, 26 May 2011 21:13:19 -0600")
Message-ID: <8yad3j46r97.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26 2011, Grant Likely wrote:

> On Wed, May 18, 2011 at 02:50:46PM -0700, David Brown wrote:
>> This patch series moves the Qualcomm MSM gpio device drivers into the
>> drivers/gpio directory.
>> 
>> The MSM's have two flavors of gpio driver.  The one for the newer
>> v7-based chips is a bit cleaner, and can just be moved.  The one for
>> the older v6-based chips took some cleanup to get rid of numerous
>> ifdefs based on the particular machine.  Both drivers can now be
>> selected and will be used on appropriate targets.
>> 
>> There is still a minor entanglement with the MSM-specific gpiomux
>> code.  This will be cleaned up as MSM moves to use pinmux.
>> 
>> David Brown (7):
>>   msm: gpio: Remove unsupported devices
>>   msm: Remove chip-ifdefs for GPIO io mappings
>>   msm: gpio: Remove chip-specific register definitions
>>   msm: gpio: Remove ifdefs on gpio chip registers
>>   msm: gpiomux: Move public API to public header
>>   gpio_msm: Move Qualcomm v6 MSM driver into drivers
>>   gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers
>
> What's the status of this series.  I only got cc'd on the last two
> patches; did you want me to pick up the whole lot, or is it being
> merged via the msm tree?

Let me send out an update, incorporating the suggestions.  I need to
rebase these changes off of the current MSM code, since the msm-next
tree contains changes that aren't going into the merge window because of
extra ARM scrutiny.

> Alternately, if there is a git branch with these patches in it, then I
> can merge that instead of applying individually.

I'll send you a pull request after I send out the updates.

Thanks,
David

> g.
>
>> 
>>  arch/arm/mach-msm/Kconfig                       |    4 +
>>  arch/arm/mach-msm/Makefile                      |    8 -
>>  arch/arm/mach-msm/gpio-v2.c                     |  427 -----------------------
>>  arch/arm/mach-msm/gpio.c                        |  376 --------------------
>>  arch/arm/mach-msm/gpio_hw.h                     |  278 ---------------
>>  arch/arm/mach-msm/gpiomux.h                     |   17 +-
>>  arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |   10 +-
>>  arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |   10 +-
>>  arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |   10 +-
>>  arch/arm/mach-msm/include/mach/msm_iomap.h      |    2 +
>>  arch/arm/mach-msm/io.c                          |   12 +-
>>  drivers/gpio/Kconfig                            |   16 +
>>  drivers/gpio/Makefile                           |    2 +
>>  drivers/gpio/msm_v1.c                           |  387 ++++++++++++++++++++
>>  drivers/gpio/msm_v1.h                           |  271 ++++++++++++++
>>  drivers/gpio/msm_v2.c                           |  427 +++++++++++++++++++++++
>>  include/linux/msm_gpiomux.h                     |   38 ++
>>  17 files changed, 1166 insertions(+), 1129 deletions(-)
>>  delete mode 100644 arch/arm/mach-msm/gpio-v2.c
>>  delete mode 100644 arch/arm/mach-msm/gpio.c
>>  delete mode 100644 arch/arm/mach-msm/gpio_hw.h
>>  create mode 100644 drivers/gpio/msm_v1.c
>>  create mode 100644 drivers/gpio/msm_v1.h
>>  create mode 100644 drivers/gpio/msm_v2.c
>>  create mode 100644 include/linux/msm_gpiomux.h
>> 
>> -- 
>> Sent by an employee of the Qualcomm Innovation Center, Inc.
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>> 

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
