Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1GBV1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:27:40 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15519 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab1GBV1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:27:39 -0400
Date: Sat, 2 Jul 2011 23:18:21 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Guenter Roeck <guenter.roeck@ericsson.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon: Don't leak info in adm1275_probe
In-Reply-To: <20110702211451.GA11378@ericsson.com>
Message-ID: <alpine.LNX.2.00.1107022317450.16316@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107022202520.16316@swampdragon.chaosbits.net> <20110702211451.GA11378@ericsson.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jul 2011, Guenter Roeck wrote:

> On Sat, Jul 02, 2011 at 04:04:29PM -0400, Jesper Juhl wrote:
> > In drivers/hwmon/adm1275.c:adm1275_probe() we'll leak the memory
> > allocated to 'info' if the call to i2c_smbus_read_byte_data() returns
> > less than zero.
> > 
> > This patch fixes the leak by simply calling kfree(info) when needed.
> > I also considered just moving the 'info' memory allocation below the
> > call to i2c_smbus_read_byte_data(), but I was not sure if it mattered
> > to get the -ENOMEM first in that case or if it would be bad to first
> > have a successful i2c_smbus_read_byte_data() call and then fail the
> > mem alloc, so I stuck with the safe option.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Hi Jesper,
> 
> the fix for this problem is already enqueued as 
> "hwmon: (adm1275) Free allocated memory if probe function fails".
> 
> There is also a second error condition, which occurs if pmbus_do_probe() 
> returns an error.
> 

Ok, cool, then that's taken care of. I'll just drop the patch from my 
personal queue. Thanks.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

