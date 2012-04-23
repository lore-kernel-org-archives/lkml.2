Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab2DWQsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:48:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51946 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab2DWQso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:48:44 -0400
Message-ID: <4F9587E8.1050702@gmail.com>
Date: Mon, 23 Apr 2012 09:48:40 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 2/2] i2c/of: Automatically populate i2c mux busses
 from device tree data.
References: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com> <1334265263-13549-3-git-send-email-ddaney.cavm@gmail.com> <20120422162008.GA4201@pengutronix.de>
In-Reply-To: <20120422162008.GA4201@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2012 09:20 AM, Wolfram Sang wrote:
> On Thu, Apr 12, 2012 at 02:14:23PM -0700, David Daney wrote:
>> From: David Daney<david.daney@cavium.com>
>>
>> For 'normal' i2c bus drivers, we can call of_i2c_register_devices()
>> and have the device tree framework automatically populate the bus with
>> the devices specified in the device tree.
>>
>> This patch adds a common code to the i2c mux framework to have the mux
>> sub-busses be populated by the of_i2c_register_devices() too.  If the
>> mux device has an of_node, we populate the sub-bus' of_node so that
>> the subsequent call to of_i2c_register_devices() will find the
>> corresponding devices.
>>
>> It seemed better to put this logic in i2c_add_mux_adapter() rather
>> than the individual mux drivers, as they will all probably want to do
>> the same thing.
>
> Both patches looking mostly good, two things here:
>
>> +	/*
>> +	 * Try to get populate the mux adapter's of_node, expands to
>
> "get populate"? I'd think you mean "populate" only, but am not sure
> enough to fix it myself.

You are correct.

>
>> +	 * nothing if !CONFIG_OF.
>> +	 */
>> +	if (mux_dev->of_node) {
>> +		struct device_node *child;
>> +		u32 reg;
>> +		int ret;
>
> We have a "ret" already in this function.
>

Good catch.  That definition of "ret" could (and should) be removed. 
The code works correctly, but fails the elegance test.

I can send a new patch set with those corrections, or if you prefer, you 
could commit these making the changes yourself.

Which do you prefer?

David Daney

