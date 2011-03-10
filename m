Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1CJD5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 22:57:11 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28138 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1CJD5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 22:57:08 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6280"; a="79071452"
Message-ID: <4D784BF6.1040700@codeaurora.org>
Date: Thu, 10 Mar 2011 09:26:38 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, davidb@codeaurora.org,
        "David S. Miller" <davem@davemloft.net>,
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
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-5-git-send-email-adharmap@codeaurora.org> <20110308233045.GB2717@opensource.wolfsonmicro.com> <4D784730.4010307@codeaurora.org>
In-Reply-To: <4D784730.4010307@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhi,

On 3/10/2011 9:06 AM, Abhijeet Dharmapurikar wrote:
> Mark Brown wrote:
>> On Mon, Mar 07, 2011 at 10:09:48PM -0800, adharmap@codeaurora.org wrote:
>>
>>> +    mpp_chip->gpio_chip.label = PM8XXX_MPP_DEV_NAME;
>>> +    mpp_chip->gpio_chip.direction_input = pm8xxx_mpp_dir_input;
>>> +    mpp_chip->gpio_chip.direction_output = pm8xxx_mpp_dir_output;
>>> +    mpp_chip->gpio_chip.to_irq = pm8xxx_mpp_to_irq;
>>> +    mpp_chip->gpio_chip.get = pm8xxx_mpp_get;
>>> +    mpp_chip->gpio_chip.set = pm8xxx_mpp_set;
>>> +    mpp_chip->gpio_chip.dbg_show = pm8xxx_mpp_dbg_show;
>>> +    mpp_chip->gpio_chip.ngpio = pdata->core_data.nmpps;
>>> +    mpp_chip->gpio_chip.can_sleep = 1;
>>> +    mpp_chip->gpio_chip.dev = &pdev->dev;
>>> +    mpp_chip->gpio_chip.base = pdata->mpp_base;
>>
>> It's seems really odd that you're adding gpiolib stuff here when you've
>> also got a separate gpiolib driver.  Possibly this all shouldn't
>> actually be split up as much as it is - there's also the issue with the
>> gpiolib driver needing to peer into the interrupt controller.  It might
>> simplify the code if things were merged more.
> 
> I dont think merging code will help here. gpio lines and mpp lines are very different piece of hardware,they have a different register map and different config attributes. They do fall under the generic 'gpiolib' umbrella, but it seems clean to keep them separate.
> 
> I agree with you that gpio code needs to call on interrupt controller ( a complicated hardware design) but I think I have a clean software implementation to manage it.
> 

It would be good to add that MPP do have more functionality than normal GPIO. So, I expect that in future
we might have few exported APIs beyond gpiolib integration. 

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
