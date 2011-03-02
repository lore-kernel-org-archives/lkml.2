Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1CBGiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 01:38:16 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:16632 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950Ab1CBGiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 01:38:15 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: <linux-kernel@vger.kernel.org>, "'Ewe, Kok Howg'" <kok.howg.ewe@intel.com>,
        "'Lai, Mee Sim'" <mee.sim.lai@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
References: <F5323EE7947C4C1CB0868F843FB4F917@hacdom.okisemi.com> <AANLkTim4z7vfyNceLYZhGzpYaECeSfLOYjzEhT9JFvJH@mail.gmail.com>
Subject: RE: About GPIO interrupt function with sysfs
Date: Wed, 2 Mar 2011 15:38:13 +0900
Message-ID: <BF5CB373A5A948A2976AE727EA3F6B70@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcvPBM8B3yxMotRjTs+zCREt+zhMmQJnV41A
In-Reply-To: <AANLkTim4z7vfyNceLYZhGzpYaECeSfLOYjzEhT9JFvJH@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Friday, February 18, 2011 9:43 AM, Grant Likely wrote:
> > Can our GPIO driver (pch_gpio) have interrupt function?
> 
> yes.
Need your help.

I try to add interrupt function to GPIO driver of Intel EG20T PCH(pch_gpio.c).

However, executing "echo xxx > export", there is not "edge" file in /sys/class/gpio/gpioxxx/.

Seeing source code in gpio_export@gpiolib.c, like below

int gpio_export(unsigned gpio, bool direction_may_change)
{
snip...

	if (!status && gpio_to_irq(gpio) >= 0
			&& (direction_may_change
				|| !test_bit(FLAG_IS_OUT,
					&desc->flags))) {
		status = device_create_file(dev,
				&dev_attr_edge);
		printk("%s:device_create_file!!! status=0x%x\n", __func__, status);
	}

snip...
}

The above "device_create_file(dev, &dev_attr_edge);" is not executed.

Seeing gpio_to_irq@arch/x86/include/asm/gpio.h, like below.

static inline int gpio_to_irq(unsigned int gpio)
{
	return -ENOSYS;
}

Thus,  device_create_file for "edge" is never executed.

Could you tell me how to create "edge" file ?

With Best Regards,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

