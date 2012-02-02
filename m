Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2BBAyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:54:01 -0500
Received: from mail4.aviatnet.com ([192.147.115.31]:10517 "EHLO
	mail4.aviatnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab2BBAyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:54:00 -0500
Subject: Re: [PATCH v3] rtc: ds1307: generalise ram size and offset
From: Austin Boyle <Austin.Boyle@aviatnet.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20120119194541.GA32483@pengutronix.de>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
	 <20120111110650.GC2605@pengutronix.de>
	 <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
	 <20120119194541.GA32483@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 2 Feb 2012 13:37:37 +1300
Message-ID: <1328143057.3159.34.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.1.34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

I'm sorry about the slow response - I was away at linux.conf.au and then
haven't found enough time since I got back. 

On Thu, 2012-01-19 at 20:45 +0100, Wolfram Sang wrote:
> Sorry, found another thing.
> 
> > +	if (chip) {
> > +		if (chip->nvram_size)
> > +			ds1307->nvram_size = chip->nvram_size;
> > +		if (chip->nvram_offset)
> > +			ds1307->nvram_offset = chip->nvram_offset;
> > +	}
> 
> I moved only the assignments...
> 
> >  
> >  	buf = ds1307->regs;
> >  	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
> > @@ -893,11 +907,12 @@ read_rtc:
> >  		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
> >  	}
> >  
> > -	if (chip && chip->nvram56) {
> > +	if (chip && chip->nvram_size) {
> 
> .. to here when I saw...
> 
> > +		nvram.size = ds1307->nvram_size;
> 
> ... that nvram is static and we are changing it. Yeah, it is very unlikely but
> if we have two RTC with different nvram sizes, one of them will not work correctly.
I see the issue. Am I right that it would only occur when you have two
I2C buses, each with one of the RTC chips supported by this driver?

The fix I thought of would be to add a 'struct bin_attribute' pointer to
'struct ds1307' and then in the probe function allocate the structure,
set the size & callbacks, and pass it as an argument to
sysfs_create_bin_file. Do you think this is viable? 

It looks like Andrew Morton has already added this patch to the -mm
tree. Has he also grabbed the patches that this depends on?

Thanks,
Austin.



