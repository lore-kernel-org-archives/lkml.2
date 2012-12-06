Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422908Ab2LFKzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:55:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60317 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965076Ab2LFKzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:55:05 -0500
Message-ID: <50C07984.8000003@ti.com>
Date: Thu, 6 Dec 2012 11:55:00 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: twl4030: Correct status reporting when the GPIO
 is used as output
References: <1354700985-4453-1-git-send-email-peter.ujfalusi@ti.com> <20121205224813.584123E0E22@localhost>
In-Reply-To: <20121205224813.584123E0E22@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 11:48 PM, Grant Likely wrote:
>> -	base = REG_GPIODATAIN1 + d_bnk;
>> +	direction = gpio_twl4030_read(REG_GPIODATADIR1 + d_bnk);
>> +	if (direction > 0 && (direction >> d_off) & 0x1)
>> +		base = REG_SETGPIODATAOUT1 + d_bnk;
>> +	else
>> +		base = REG_GPIODATAIN1 + d_bnk;
>> +
> 
> This is probably quite expensive considering that reads need to go out
> the i2c bus. Things like the output state and the pin direction should
> be cached by the driver in its private data structure so that you don't
> add an additional i2c round trip.

True. I have sent the v2, which grown a bit since I did not wanted to add more
global variable to this driver.

-- 
Péter
