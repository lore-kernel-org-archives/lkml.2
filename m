Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0GXPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 11:09:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38883 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab0GXPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:09:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6052"; a="48435728"
Message-ID: <4C4B0201.9060106@codeaurora.org>
Date: Sat, 24 Jul 2010 20:38:49 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Kenneth Heitke <kheitke@codeaurora.org>
CC: khali@linux-fr.org, ben-linux@fluff.org, linux-arm-msm@vger.kernel.org,
        Crane Cai <crane.cai@amd.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: QUP based bus driver for Qualcomm MSM chipsets
References: <1279853264-16311-1-git-send-email-kheitke@codeaurora.org> <4C494086.5080408@codeaurora.org> <4C49E5EE.2070103@codeaurora.org>
In-Reply-To: <4C49E5EE.2070103@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ken,

> 
>>
>>> +
>>> +    if (!pdata->msm_i2c_config_gpio) {
>>> +        dev_err(&pdev->dev, "config_gpio function not initialized\n");
>>> +        ret = -ENOSYS;
>>> +        goto err_config_failed;
>>> +    }
>>
>> I don't agree here. What if I do all the gpio configuration from the bootloader itself,
>> because I know that the device I am working on is production device and don't change
>> its configuration, then why I should provide the pdata hooks from the board files?
> 
> The reason that this hook is required is so that the driver can enable and disable the GPIOs as needed (although we currently only enable them).
> 
>>
>> Please also specify what are the operations we are doing in the msm_i2c_config_gpio?
> 
> Takes ownership of the GPIOs that are needed and assigns the ownership to the i2c controller.  The drive strength is also set.

Right, so due to these reasons I prefer not to have __must__ have check for pdata->msm_i2c_config_gpio hook's unavailability. It
might happen that some of the systems do all these ownership and pad muxing into the bootloader itself.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
