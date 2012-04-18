Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2DRIYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:24:00 -0400
Received: from antcom.de ([188.40.178.216]:59867 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab2DRIX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:23:58 -0400
Message-ID: <4F8E7A19.303@antcom.de>
Date: Wed, 18 Apr 2012 10:23:53 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 1/8] ohci-nxp: Driver cleanup
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <1334682507-15055-2-git-send-email-stigge@antcom.de> <20120417205740.GI6498@mwanda>
In-Reply-To: <20120417205740.GI6498@mwanda>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 10:57 PM, Dan Carpenter wrote:
> On Tue, Apr 17, 2012 at 07:08:20PM +0200, Roland Stigge wrote:
>> @@ -435,6 +436,7 @@ static int __devinit usb_hcd_nxp_probe(s
>>  	}
>>  
>>  	__raw_writel(__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN, USB_CTRL);
>> +	__raw_writel(__raw_readl(USB_CTRL) & ~USB_DEV_NEED_CLK_EN, USB_CTRL);
>>  
>>  	/* Set to enable all needed USB clocks */
>>  	__raw_writel(USB_CLOCK_MASK, USB_OTG_CLK_CTRL);
> 
> What does this chunk do?  Is this part of the "* Fixed controller
> initialization (bits)" bullet point?  How does it affect the user?
> Should it be included in the 3.4 kernel?

Thanks for the hint! I will drop this hunk. Originally, it made sure
that USB_DEV_NEED_CLK_EN is disabled but due to another change:

usb_hcd_nxp_probe() {
...
__raw_writel(USB_SLAVE_HCLK_EN | PAD_CONTROL_LAST_DRIVEN, USB_CTRL);

this bit is already cleared anyway.

(Would have been uncritical for v3.4 anyway, relating only to the other
changes introduced in my 3.5 patches.)

Roland
