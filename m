Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab2CKKQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 06:16:49 -0400
Received: from antcom.de ([188.40.178.216]:34280 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab2CKKQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 06:16:46 -0400
Message-ID: <4F5C7B8B.7050508@antcom.de>
Date: Sun, 11 Mar 2012 11:16:43 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH v5 3/3] USB: ohci-nxp: Support for LPC32xx
References: <1331408166-11607-1-git-send-email-stigge@antcom.de> <1331408166-11607-4-git-send-email-stigge@antcom.de> <20120310204955.GA14564@pengutronix.de> <4F5BD5BE.3000808@antcom.de> <20120311074323.GA30894@pengutronix.de>
In-Reply-To: <20120311074323.GA30894@pengutronix.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/03/12 08:43, Wolfram Sang wrote:
>>> And while we are at it: Could you also try replacing
>>> i2c_write() with i2c_smbus_write_byte_data(isp1301_i2c_client,
>>> reg, val)?
>> 
>> Interestingly now, replacing i2c_write() calls with 
>> i2c_smbus_write_byte_data() did _not_ work (hardware
>> initialization failure). I guess this is due to the differences
>> between i2c and smbus, and the hardware only handles the former
>> correctly?
> 
> Did you take into consideration that the smbus-call has (client,
> reg, val) as arguments while i2c_write has (val, reg), that is you
> have to swap the arguments?

Yes, that's it! :-)

I'll update my patch to not use i2c_write() anymore.

For the remaining i2c_write() in the current kernel driver, I will
include an additional patch to remove it completely in favour of
i2c_smbus_write_byte_data().

Thanks,

Roland
