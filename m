Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0DXPH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 11:07:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:39008 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753192Ab0DXPH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 11:07:56 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+wylxSfFSwRm2aSce7EP+PHR2OxugwZls4E/khnn
	PkM1ctp7JCbpuE
Message-ID: <4BD30944.6060302@gmx.de>
Date: Sat, 24 Apr 2010 17:07:48 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       Deepak Saxena <dsaxena@laptop.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [RFC] Second OLPC Viafb series
References: <1272058093-20914-1-git-send-email-corbet@lwn.net>
In-Reply-To: <1272058093-20914-1-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jonathan Corbet schrieb:
> So this is the second series of viafb patches - the stuff that I was really
> working toward since the beginning.  They depend on the previously-posted
> first series.  What's added here is a big refactoring of the driver to
> split its functions apart and the addition of code for GPIO, interrupt,
> DMA, and camera management.

this looks like a step in the right direction. But I have the feeling 
that it needs a lot of work before I'd consider it useful for mainline.

> Florian, I incorporated your indexed port I/O patch, since it was an
> obvious improvement and I was reworking that stuff anyway.

Thanks.
Could you please also take the proc fix (6) in your upstream branch as 
it is clearly a bugfix (and tainting the kernel is also something that 
should be avoided)

> The full series of patches can be pulled from:
> 
> 	git://git.lwn.net/linux-2.6.git viafb-posted

Probably I should use this the next time as this series again did not 
cleanly apply so I just fired patch on it (which worked as it was mostly 
due to a slight difference in our compile fixes).

So I wanted to runtime test it as you said that it might fix the 
I2C/GPIO issue I debugged. I gave up for now after hitting the following 
errors:

drivers/video/via/via-gpio.c:74: error: field 'gpio_chip' has incomplete 
type

so we should either select GPIOLIB or add ifdef's to avoid the dependency?

After that I hit

drivers/video/via/via_i2c.o: In function `init_module':
via_i2c.c:(.text+0x309): multiple definition of `init_module'
drivers/video/via/viafbdev.o:viafbdev.c:(.init.text+0x0): first defined here
drivers/video/via/via_i2c.o: In function `cleanup_module':
via_i2c.c:(.text+0x10): multiple definition of `cleanup_module'
drivers/video/via/viafbdev.o:viafbdev.c:(.exit.text+0x0): first defined here
drivers/video/via/via-gpio.o: In function `init_module':
via-gpio.c:(.text+0x1f6): multiple definition of `init_module'
drivers/video/via/viafbdev.o:viafbdev.c:(.init.text+0x0): first defined here
drivers/video/via/via-gpio.o: In function `cleanup_module':
via-gpio.c:(.text+0x0): multiple definition of `cleanup_module'
drivers/video/via/viafbdev.o:viafbdev.c:(.exit.text+0x0): first defined here

Guess that means you should only have one module init/exit per module. 
So either making via_i2c and via_gpio separate modules or calling these 
functions directly from the init/exit functions.

That's it for now as I'm really supposed to do some other stuff, too.


Thanks,

Florian Tobias Schandinat
