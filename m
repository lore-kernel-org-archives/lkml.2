Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0IQOGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:06:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50109 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752377Ab0IQOGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:06:30 -0400
Date: Fri, 17 Sep 2010 15:06:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, lrg@slimlogic.co.uk
Subject: Re: i2c: Re: #2 (Re: More modaliases + patchtool))
Message-ID: <20100917140647.GA18367@opensource.wolfsonmicro.com>
References: <4C6BE292.3060307@bspu.unibel.by>
 <201008191020.52861.rusty@rustcorp.com.au>
 <4C6D26BC.9040805@bspu.unibel.by>
 <201009111144.34078.rusty@rustcorp.com.au>
 <4C936EA5.2040506@bspu.unibel.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C936EA5.2040506@bspu.unibel.by>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 04:35:33PM +0300, Dzianis Kahanovich wrote:
> ...
> + 1 attach for "next" branch.

Again, please try to follow the process in SubmittingPatches for sending
patches.

> I unsure in requrement of i2c modaliases, may be this bus undetectable, but I
> not play with special tools with vendors exclude VIA.

I2C is not probeable but drivers can be autoloaded since boards must
register devices before they can be probed.

> --- linux-2.6.36-rc4-git3/sound/soc/s3c24xx/neo1973_wm8753.c	2010-08-02 01:11:14.000000000 +0300
> +++ b/sound/soc/s3c24xx/neo1973_wm8753.c	2010-09-17 12:39:07.917253497 +0300
> @@ -698,6 +698,9 @@ static void __exit neo1973_exit(void)
>  	platform_device_unregister(neo1973_snd_device);
>  }
>  
> +
> +MODULE_DEVICE_TABLE(i2c, lm4857_i2c_id);
> +

No, this shouldn't be added - this driver should not be loaded based on
the presence of the LM4857 since it is specific to the OpenMoko Neo1973
system.  This is largely because the LM4857 support is a hideous bodge
which should get fixed at some point (it ought to be in a separate
driver in the CODECs directory rather than part of the OpenMoko machine
driver).

> --- linux-2.6.36-rc4-git3/sound/soc/codecs/tlv320dac33.c	2010-09-17 12:30:31.000000000 +0300
> +++ b/sound/soc/codecs/tlv320dac33.c	2010-09-17 12:39:07.801200070 +0300
> @@ -1712,6 +1712,9 @@ static int __init dac33_module_init(void
>  	}
>  	return 0;
>  }
> +
> +MODULE_DEVICE_TABLE(i2c, tlv320dac33_i2c_id);
> +

This change is OK but should be moved next to the actual table.
