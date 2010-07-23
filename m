Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab0GWUuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:50:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31481 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0GWUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:50:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6052"; a="48471247"
Message-ID: <4C4A0086.3040009@codeaurora.org>
Date: Fri, 23 Jul 2010 14:50:14 -0600
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
> Is it just me who is uncomfortable with this?
> 
> If I am not mistaken, you still have to update the i2c_client structure
> when using the SMBus API.

Yes, you are correct if the SMBus API is being used.

Each SSBI transaction consists of an address and a data word.  I need to 
get the address information somehow and I didn't want to have to fetch 
this information from the data buffer passed in for the clients.

> 
> And how do you intend to bind a driver to an SSBI device if there is not a
> single address to bind to?

There is only one device per controller therefore the binding is done 
using the bus number.  If I have 3 devices, then I have 3 independent buses.

> 
> The Qualcomm SSBI patent mentiones the possibility of adding logic to chips
> to be accessible over both SSBI and the three wire SBI interface. The SBI
> interface on the other hand is even closer to I2C and requires the use of
> a slave ID byte. If you didn't abuse the address field, you could write
> drivers that work on both interfaces.

The driver doesn't support the three wire SBI interface.  That interface 
   has been replaced with the single wire interface and won't be support 
under Linux.

> 
> Why not use one of the special addresses mentioned in the I2C specification
> for SSBI? 0x02 might be appropriate.
> 

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
