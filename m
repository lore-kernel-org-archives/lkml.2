Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2BIWDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:03:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42502 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351Ab2BIWDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:03:23 -0500
Message-ID: <4F34429E.8070605@gmail.com>
Date: Thu, 09 Feb 2012 16:03:10 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, b-cousson@ti.com,
        Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH v4 4/4] gpio: pl061: enable interrupts with DT style binding
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com> <1328308512-22594-5-git-send-email-robherring2@gmail.com> <20120209200435.GB2493@r65073-Latitude-D630>
In-Reply-To: <20120209200435.GB2493@r65073-Latitude-D630>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/09/2012 02:04 PM, Shawn Guo wrote:
> On Fri, Feb 03, 2012 at 04:35:12PM -0600, Rob Herring wrote:
> ...
>> @@ -126,18 +127,16 @@ static void pl061_set_value(struct gpio_chip *gc, unsigned offset, int value)
>>  static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
>>  {
>>  	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
>> -
>> -	if (chip->irq_base <= 0)
>> -		return -EINVAL;
>> -
>> -	return chip->irq_base + offset;
>> +	if (!chip->irq_gc)
>> +		return -ENXIO;
>> +	return irq_find_mapping(chip->irq_gc->domain, offset);
> 
> If I understand the driver correctly, it will add a linear domain for
> dt case.  Do you have code somewhere creating the mapping before this
> irq_find_mapping gets called here?  The reason I'm asking this is I
> have to call irq_create_mapping rather than irq_find_mapping here to
> get imx gpio driver working with linear domain, otherwise the
> irq_find_mapping call will fail.
> 

Right, the user has to call irq_of_parse_and_map (which calls
irq_create_mapping ultimately). Interrupts are allocated on demand. The
dts needs to declare the gpio controller as an interrupt-controller and
the node using the gpio line needs to set its interrupt parent and
interrupt connection

Rob

> Regards,
> Shawn
> 
>>  }
