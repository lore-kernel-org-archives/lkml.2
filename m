Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1GBVPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:15:48 -0400
Received: from imr4.ericy.com ([198.24.6.8]:42734 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab1GBVPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:15:46 -0400
Date: Sat, 2 Jul 2011 14:14:51 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon: Don't leak info in adm1275_probe
Message-ID: <20110702211451.GA11378@ericsson.com>
References: <alpine.LNX.2.00.1107022202520.16316@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107022202520.16316@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 02, 2011 at 04:04:29PM -0400, Jesper Juhl wrote:
> In drivers/hwmon/adm1275.c:adm1275_probe() we'll leak the memory
> allocated to 'info' if the call to i2c_smbus_read_byte_data() returns
> less than zero.
> 
> This patch fixes the leak by simply calling kfree(info) when needed.
> I also considered just moving the 'info' memory allocation below the
> call to i2c_smbus_read_byte_data(), but I was not sure if it mattered
> to get the -ENOMEM first in that case or if it would be bad to first
> have a successful i2c_smbus_read_byte_data() call and then fail the
> mem alloc, so I stuck with the safe option.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Hi Jesper,

the fix for this problem is already enqueued as 
"hwmon: (adm1275) Free allocated memory if probe function fails".

There is also a second error condition, which occurs if pmbus_do_probe() 
returns an error.

Thanks,
Guenter
