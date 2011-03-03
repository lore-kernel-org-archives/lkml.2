Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab1CCS4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:56:36 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:57010 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab1CCS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:56:35 -0500
Date: Thu, 3 Mar 2011 11:56:32 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, "'Ewe, Kok Howg'" <kok.howg.ewe@intel.com>,
        "'Lai, Mee Sim'" <mee.sim.lai@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
Subject: Re: About GPIO interrupt function with sysfs
Message-ID: <20110303185632.GL22940@angua.secretlab.ca>
References: <F5323EE7947C4C1CB0868F843FB4F917@hacdom.okisemi.com>
 <AANLkTim4z7vfyNceLYZhGzpYaECeSfLOYjzEhT9JFvJH@mail.gmail.com>
 <BF5CB373A5A948A2976AE727EA3F6B70@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BF5CB373A5A948A2976AE727EA3F6B70@hacdom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 03:38:13PM +0900, Tomoya MORINAGA wrote:
> Hi Grant,
> 
> On Friday, February 18, 2011 9:43 AM, Grant Likely wrote:
> > > Can our GPIO driver (pch_gpio) have interrupt function?
> > 
> > yes.
> Need your help.
> 
> I try to add interrupt function to GPIO driver of Intel EG20T PCH(pch_gpio.c).
> 
> However, executing "echo xxx > export", there is not "edge" file in /sys/class/gpio/gpioxxx/.
> 
> Seeing source code in gpio_export@gpiolib.c, like below
> 
> int gpio_export(unsigned gpio, bool direction_may_change)
> {
> snip...
> 
> 	if (!status && gpio_to_irq(gpio) >= 0
> 			&& (direction_may_change
> 				|| !test_bit(FLAG_IS_OUT,
> 					&desc->flags))) {
> 		status = device_create_file(dev,
> 				&dev_attr_edge);
> 		printk("%s:device_create_file!!! status=0x%x\n", __func__, status);
> 	}
> 
> snip...
> }

Hmmm, I haven't looked at that code yet.  I didn't realize that the
irq data was exported to userspace (ignore my last email).

> 
> The above "device_create_file(dev, &dev_attr_edge);" is not executed.
> 
> Seeing gpio_to_irq@arch/x86/include/asm/gpio.h, like below.
> 
> static inline int gpio_to_irq(unsigned int gpio)
> {
> 	return -ENOSYS;
> }
> 
> Thus,  device_create_file for "edge" is never executed.
> 
> Could you tell me how to create "edge" file ?

I don't know.  I'll need to dig into that code before I can answer.  I
suggest digging into it yourself to figure out the answer as I cannot
promise that I'll get to it anytime soon.

g.
