Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab1CCDi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:38:27 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14100 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab1CCDiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:38:25 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77495463"
Message-ID: <4D6F0D30.1050403@codeaurora.org>
Date: Wed, 02 Mar 2011 19:38:24 -0800
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
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD 1/6] mfd: pm8921: Add PMIC 8921 core driver
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org> <1299104001-5240-2-git-send-email-adharmap@codeaurora.org> <20110302222850.GA32325@opensource.wolfsonmicro.com>
In-Reply-To: <20110302222850.GA32325@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Mar 02, 2011 at 02:13:16PM -0800, adharmap@codeaurora.org wrote:
> 
>> +config MFD_PM8XXX
>> +	tristate "Support for Qualcomm PM8xxx subdevices"
>> +	help
>> +	  This option enables the usage of various Qualcomm PMIC 8xxx subdevice
>> +	  drivers. This is required in order to use generic PM8xxx subdevice
>> +	  drivers. Selecting with option will result in PM8xxx subdevice
>> +	  drivers being compiled by default.
> 
> As this is selected by the driver it shouldn't have any help text -
> there's no point in users seeing the option since it's useless by
> itself.  If we get enough to make an option useful either a menu or
> dependencies from the individual MFDs would be a better option.

Agree will fix this.
> 
>> +static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
>> +					   *pdata,
>> +					   struct pm8921 *pmic)
>> +{
>> +	return 0;
>> +}
> 
> This looks suspicious.

True, the next patch fills in this function. Will remove it from here.

> 
>> +static int __init pm8921_init(void)
>> +{
>> +	return platform_driver_register(&pm8921_driver);
>> +}
>> +postcore_initcall(pm8921_init);
> 
> Typically subsys_initcall() has been used.

Yes will change this and others to subsys_initcall()


--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
