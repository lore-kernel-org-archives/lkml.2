Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967857Ab2ERJM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:12:28 -0400
Received: from antcom.de ([188.40.178.216]:53254 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967112Ab2ERJMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:12:21 -0400
Message-ID: <4FB61272.5080700@antcom.de>
Date: Fri, 18 May 2012 11:12:18 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: axel.lin@gmail.com, riyer@nvidia.com, michael.hennerich@analog.com,
        grant.likely@secretlab.ca, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com
Subject: Re: [PATCH RESEND v3 1/2] input: keyboard: Add keys driver for the
 LPC32xx SoC
References: <1337199955-26441-1-git-send-email-stigge@antcom.de> <20120517173814.GA26948@core.coreip.homeip.net>
In-Reply-To: <20120517173814.GA26948@core.coreip.homeip.net>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry!

thanks for your suggestions, will include them into the next patch update.

On 05/17/2012 07:38 PM, Dmitry Torokhov wrote:
>> +	of_property_read_u32(np, "keypad,num-rows", &rows);
>> +	of_property_read_u32(np, "keypad,num-columns", &columns);
>> +	if (!rows || rows != columns) {
>> +		dev_err(dev, "rows and columns must be specified and be equal!\n");
> 
> Why?

The LPC32xx key scanner hardware is always configured with a square
matrix (rows == columns). So I had the choice to force "keypad,num-rows"
== "keypad,num-columns" (as done currently) to show potential error to
the DTS/DTB provider, or ignore problems here and use
max("keypad,num-rows", "keypad,num-columns") for actual hardware setup.

(You can and will leave out unconnected keys in the keymap anyway.)

So do you think we should change my current approach here?

Thanks in advance,

Roland
