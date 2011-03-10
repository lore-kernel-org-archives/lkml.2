Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab1CJDgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 22:36:19 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63886 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1CJDgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 22:36:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6280"; a="78874237"
Message-ID: <4D784730.4010307@codeaurora.org>
Date: Wed, 09 Mar 2011 19:36:16 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        Thomas Glexiner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD v2 4/6] mfd: pm8xxx-mpp: Add pm8xxx MPP
 driver
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-5-git-send-email-adharmap@codeaurora.org> <20110308233045.GB2717@opensource.wolfsonmicro.com>
In-Reply-To: <20110308233045.GB2717@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Mon, Mar 07, 2011 at 10:09:48PM -0800, adharmap@codeaurora.org wrote:
> 
>> +	mpp_chip->gpio_chip.label = PM8XXX_MPP_DEV_NAME;
>> +	mpp_chip->gpio_chip.direction_input = pm8xxx_mpp_dir_input;
>> +	mpp_chip->gpio_chip.direction_output = pm8xxx_mpp_dir_output;
>> +	mpp_chip->gpio_chip.to_irq = pm8xxx_mpp_to_irq;
>> +	mpp_chip->gpio_chip.get = pm8xxx_mpp_get;
>> +	mpp_chip->gpio_chip.set = pm8xxx_mpp_set;
>> +	mpp_chip->gpio_chip.dbg_show = pm8xxx_mpp_dbg_show;
>> +	mpp_chip->gpio_chip.ngpio = pdata->core_data.nmpps;
>> +	mpp_chip->gpio_chip.can_sleep = 1;
>> +	mpp_chip->gpio_chip.dev = &pdev->dev;
>> +	mpp_chip->gpio_chip.base = pdata->mpp_base;
> 
> It's seems really odd that you're adding gpiolib stuff here when you've
> also got a separate gpiolib driver.  Possibly this all shouldn't
> actually be split up as much as it is - there's also the issue with the
> gpiolib driver needing to peer into the interrupt controller.  It might
> simplify the code if things were merged more.

I dont think merging code will help here. gpio lines and mpp lines are 
very different piece of hardware,they have a different register map and 
different config attributes. They do fall under the generic 'gpiolib' 
umbrella, but it seems clean to keep them separate.

I agree with you that gpio code needs to call on interrupt controller ( 
a complicated hardware design) but I think I have a clean software 
implementation to manage it.

-- 
--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
