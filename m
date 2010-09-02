Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0IBTpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:45:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49041 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0IBTpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:45:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6093"; a="53187219"
Message-ID: <4C7FFEC2.2050502@codeaurora.org>
Date: Thu, 02 Sep 2010 12:45:06 -0700
From: Gregory Bean <gbean@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: Gregory Bean <gbean@codeaurora.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2 v2] msm: Install the Google-Android gpio driver.
References: <1283384380-24997-1-git-send-email-gbean@codeaurora.org> <20100902102752.GB20737@trinity.fluff.org>
In-Reply-To: <20100902102752.GB20737@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +#define MSM_GPIO_OUT_0         MSM_GPIO1_REG(0x00)  /* gpio  15-0  */
>> +#define MSM_GPIO_OUT_1         MSM_GPIO2_REG(0x00)  /* gpio  42-16 */
>> +#define MSM_GPIO_OUT_2         MSM_GPIO1_REG(0x04)  /* gpio  67-43 */
>> +#define MSM_GPIO_OUT_3         MSM_GPIO1_REG(0x08)  /* gpio  94-68 */
>> +#define MSM_GPIO_OUT_4         MSM_GPIO1_REG(0x0C)  /* gpio 106-95 */
>> +#define MSM_GPIO_OUT_5         MSM_GPIO1_REG(0x50)  /* gpio 107-121 */
>> +
>> +/* same pin map as above, output enable */
>> +#define MSM_GPIO_OE_0          MSM_GPIO1_REG(0x10)
>> +#define MSM_GPIO_OE_1          MSM_GPIO2_REG(0x08)
>> +#define MSM_GPIO_OE_2          MSM_GPIO1_REG(0x14)
>> +#define MSM_GPIO_OE_3          MSM_GPIO1_REG(0x18)
>> +#define MSM_GPIO_OE_4          MSM_GPIO1_REG(0x1C)
>> +#define MSM_GPIO_OE_5          MSM_GPIO1_REG(0x54)
>
> do we need each and every register defined in the header? would simply
> the base of each gpio bank make this header file much smaller? or
> turn it into MSM_GPIO_OE(x) ?

Unfortunately, the registers are not regularly spaced.  There are small 
sections of regularity, but special cases abound.  I could produce 
macros or functions to calculate them, but I fear that they'd be so full 
of conditionals that the net gain would be negligible, or worse.

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
