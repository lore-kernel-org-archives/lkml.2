Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2CJW3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 17:29:23 -0500
Received: from antcom.de ([188.40.178.216]:38047 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab2CJW3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 17:29:22 -0500
Message-ID: <4F5BD5BE.3000808@antcom.de>
Date: Sat, 10 Mar 2012 23:29:18 +0100
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
References: <1331408166-11607-1-git-send-email-stigge@antcom.de> <1331408166-11607-4-git-send-email-stigge@antcom.de> <20120310204955.GA14564@pengutronix.de>
In-Reply-To: <20120310204955.GA14564@pengutronix.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/12 21:49, Wolfram Sang wrote:
>> -static void isp1301_configure(void) +static u16 i2c_read16(u8
>> subaddr) +{ +	u16 data; + +	i2c_master_send(isp1301_i2c_client,
>> &subaddr, 1); +	i2c_master_recv(isp1301_i2c_client, (u8 *) &data,
>> 2); + +	return data; +}
> 
> Won't i2c_smbus_read_word_data(isp1301_i2c_client, reg) do?

Yes, thank you for the hint! Replaced i2c_read16() with
i2c_smbus_read_word_data() calls.

> And while we are at it: Could you also try replacing i2c_write()
> with i2c_smbus_write_byte_data(isp1301_i2c_client, reg, val)?

Interestingly now, replacing i2c_write() calls with
i2c_smbus_write_byte_data() did _not_ work (hardware initialization
failure). I guess this is due to the differences between i2c and
smbus, and the hardware only handles the former correctly?

Roland
