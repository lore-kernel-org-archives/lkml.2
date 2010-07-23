Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab0GWScg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:32:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57588 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0GWScf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:32:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6052"; a="48448013"
Message-ID: <4C49E041.8070009@codeaurora.org>
Date: Fri, 23 Jul 2010 12:32:33 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
CC: khali@linux-fr.org, ben-linux@fluff.org, linux-arm-msm@vger.kernel.org,
        sdharia@codeaurora.org, Crane Cai <crane.cai@amd.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Single-wire Serial Bus Interface for Qualcomm MSM
 chipsets
References: <1279734768-8436-1-git-send-email-kheitke@codeaurora.org> <4C496C58.1080806@emlix.com>
In-Reply-To: <4C496C58.1080806@emlix.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Glöckner wrote:
> On 07/21/2010 07:52 PM, Kenneth Heitke wrote:
>> Unlike I2C, SSBI is a point-to-point connection, and therefore there is no
>> need to specify a slave device address. The SSBI implementation
>> overrides the slave device address to be a device register address
>> instead.  This restricts the client drivers from using the SMBus
>> communication APIs unless they update the address field (addr) of the
>> i2c_client structure prior to every SMBus function call.
> 
> 
>> +static int
>> +i2c_ssbi_write_bytes(struct i2c_ssbi_dev *ssbi, struct i2c_msg *msg)
>> +{
>> +	int ret = 0;
>> +	u8 *buf = msg->buf;
>> +	u16 len = msg->len;
>> +	u16 addr = msg->addr;
>> +
>> +	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
>> +		u32 mode2 = readl(ssbi->base + SSBI2_MODE2);
>> +		writel(SSBI_MODE2_REG_ADDR_15_8(mode2, addr),
>> +				ssbi->base + SSBI2_MODE2);
>> +	}
>> +
>> +	while (len) {
> 
> Where do you set the address if controller_type == MSM_SBI_CTRL_SSBI?
> 
>   Daniel
> 
> 

The SSBI_MODE2_REG_ADDR register contains the upper 8-bits of the 
address which is only supported by SSBI 2.0.  The lower 8 address bits 
are written as part of the SSBI_CMD_WRITE macro which is common for both 
of the controller types.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
