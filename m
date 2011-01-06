Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1AFSbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:31:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61618 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab1AFSbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HM6qiOcg1cGZ5jgWRDDpUWmxPIC4Fgmoq7OU+xPZEhzSERpsitBOMBjCeiKvzeOd5p
         GyiCS/yV1aMhdxYveU4YRtHzbbHKPJ3hipTAd9XFSUPP2VkgpFvwht0Oe9I0L9aQX5MG
         WB9HDqORi46iGz48dK2HbjqdNdZCE6vU3JuU4=
MIME-Version: 1.0
In-Reply-To: <20100930205548.66C179D401B@zog.reactivated.net>
References: <20100930205548.66C179D401B@zog.reactivated.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 6 Jan 2011 13:28:33 -0500
Message-ID: <AANLkTi=i=6U9utEsSWFvmazpSqGKBAuBw+HR0x=Ox1Bu@mail.gmail.com>
Subject: Re: [PATCH 3/3] Add VIA VX855 GPIO driver
To: Daniel Drake <dsd@laptop.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, laforge@gnumonks.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 16:55, Daniel Drake wrote:
> --- /dev/null
> +++ b/drivers/gpio/vx855_gpio.c
> @@ -0,0 +1,332 @@
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/gpio.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pci.h>
> +#include <linux/io.h>

i guess you wrote this against a much older kernel and didnt compile
against a newer one ?  it fails to build due to missing linux/slab.h
include:
  CC      drivers/gpio/vx855_gpio.o
drivers/gpio/vx855_gpio.c: In function ‘vx855gpio_probe’:
drivers/gpio/vx855_gpio.c:233: error: implicit declaration of function ‘kzalloc’
drivers/gpio/vx855_gpio.c:233: warning: assignment makes pointer from
integer without a cast
drivers/gpio/vx855_gpio.c:282: error: implicit declaration of function ‘kfree’
make[1]: *** [drivers/gpio/vx855_gpio.o] Error 1
-mike
