Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab2JSKfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:35:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47207 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758605Ab2JSKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:35:32 -0400
MIME-Version: 1.0
In-Reply-To: <507FD4EB.1080204@antcom.de>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
	<1350477107-26512-3-git-send-email-stigge@antcom.de>
	<20121017190520.GC25996@kroah.com>
	<507FD4EB.1080204@antcom.de>
Date: Fri, 19 Oct 2012 12:35:31 +0200
Message-ID: <CACRpkda35jKs9YVNDAo96=0QzdMi+jkvJAzM=nX+HCK-d5+e9Q@mail.gmail.com>
Subject: Re: [PATCH RFC 02/15 v5] gpio: Add sysfs support to block GPIO API
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>, Greg KH <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:07 PM, Roland Stigge <stigge@antcom.de> wrote:
> On 10/17/2012 09:05 PM, Greg KH wrote:
>>>
>>> +    if (value != exported) {
>>> +            if (value)
>>> +                    status = gpio_block_value_export(block);
>>> +            else
>>> +                    status = gpio_block_value_unexport(block);
>>
>> That looks like a recipie for disaster.  Why do you allow userspace to
>> do this?
>
> Exporting for gpio blocks is done as follows: writing "1" to the
> "exported" _device_ attribute of the gpio block creates the "values"
> attribute and at the same time requests the whole block (including all
> of its gpios) as "sysfs".

To me it reads like Greg's comment is basically pinpointing a flaw
in Brownell's initial design of gpio sysfs: that new sysfs files are
created and destroyed by writing into sysfs */export files from
userspace?

See commit: d8f388d8dc8d4f36539dd37c1fff62cc404ea0fc

The block GPIO stuff is just following that design pattern.

Yours,
Linus Walleij
