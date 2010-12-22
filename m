Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0LVW6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:58:02 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:24251 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752127Ab0LVW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:58:01 -0500
Message-ID: <4D1282DA.4020804@bluewatersys.com>
Date: Thu, 23 Dec 2010 11:59:38 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Alexey Charkov <alchark@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v11] ARM: Add basic architecture support for VIA/WonderMedia
 85xx SoC's
References: <AANLkTin4XqbGwznp56Xjt_zest6rxNmir0QDJWTySY4+@mail.gmail.com> <4D0FD747.9020700@bluewatersys.com> <AANLkTikAWjK7ACyt=LedhyyrhsCk1WCiyWz182CXMe9C@mail.gmail.com> <4D0FE546.7050302@bluewatersys.com> <AANLkTinyYKrhTcBMMCE4A2oFQHm11cqSZQozytGu+d6o@mail.gmail.com> <4D1011CF.9080800@bluewatersys.com> <AANLkTi=7O-HwQRcybnLSt+r+A64g=D7rZY7NbdEMFys3@mail.gmail.com> <4D110269.9030805@bluewatersys.com> <20101222211815.GA31054@alchark-u3s> <4D12730B.2030909@bluewatersys.com> <20101222222501.GA32693@alchark-u3s>
In-Reply-To: <20101222222501.GA32693@alchark-u3s>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2010 11:25 AM, Alexey Charkov wrote:
> This adds support for the family of Systems-on-Chip produced initially
> by VIA and now its subsidiary WonderMedia that have recently become
> widespread in lower-end Chinese ARM-based tablets and netbooks.
> 
> Support is included for both VT8500 and WM8505, selectable by a
> configuration switch at kernel build time.
> 
> Included are basic machine initialization files, register and
> interrupt definitions, support for the on-chip interrupt controller,
> high-precision OS timer, GPIO lines, necessary macros for early debug,
> pulse-width-modulated outputs control, as well as platform device
> configurations for the specific drivers implemented elsewhere.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> ---
> 
> This incorporates latest comments by Ryan regarding helper inlines
> in devices-{vt8500,wm8505}.c
> 
> Best regards,
> Alexey

One final nitpick :-).

> +static int vt8500_muxed_gpio_direction_input(struct gpio_chip *chip,
> +				       unsigned offset)
> +{
> +	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
> +	unsigned val = readl(regbase + 0x20 + vt8500_chip->regoff);
> +
> +	val &= ~(1 << vt8500_chip->shift << offset);
> +	writel(val, regbase + 0x20 + vt8500_chip->regoff);

The magic numbers (0x20) in the gpio functions should probably be
#defined as register names. I'm guessing this is the input enable
register? Often people do helper functions for this, i.e:

static inline void gpio_write_reg(struct vt8500_gpio_chip *chip,
				  unsigned val, unsigned reg)
{
	writel(val, regbase + chip->regoff + reg);
}

Other than that, looks good.

Reviewed-by: Ryan Mallon <ryan@bluewatersys.com>

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
