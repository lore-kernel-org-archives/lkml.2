Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2DPSLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:11:24 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63443 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab2DPSLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:11:22 -0400
Date: Mon, 16 Apr 2012 20:11:09 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 1/2] mfd: Add driver for STA2X11 MFD block
Message-ID: <20120416181109.GA32226@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120416180553.GV24130@sortiz-mobl>
References: <20120416180553.GV24130@sortiz-mobl>
  <cover.1334219873.git.rubini@gnudd.com>
  <99e873520a5e9278abfaaf9fbd514bab2c326479.1334219874.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Samuel, thanks for commenting.

> - You should not select GPIO_STA2X11 as this won't select the STA2X211 gpio
>   driver dependencies for you. So if you build this driver with GPIOLIB=n then
>   your build will fail.

Ok. I recall this now, but I've forgotten while editing.

> - Why would this one depend on STA2X11 ? I see that you're calling
>   sta2x11_get_instance() from this driver but I wonder if you could simply
>   replace the mfd->instance pointer with one pointing to the pci_dev. Not
>   depending on STA2X11 at all gives you the benefit of a much larger build
>   coverage from linux-next for example.

Right. But I need to know the instance, because other drivers will
call on mfd for some configuration, and I need to match their device
instance with the mfd one.  The sta2x11 is a complex bridge, with 4
sub-buses, but being pci you can in theory plug two such boards
in the same computer, and I'd love that setup to work properly.

>> +/* Bar 0 */
>> +enum bar0_cells {
>> +	GPIO_0 = 0,
>> +	GPIO_1,
>> +	GPIO_2,
>> +	GPIO_3,
>> +	SCTL,
>> +	SCR,
>> +	TIME,
>> +};
> Please protect those ones with a proper namespace.

I remember this and I didn't do it on purpose (but I didn't comment on
the submission because so much time had passed). I protected all the
gpio bits, but this is only a local shortcut (it's in the .c
file), to name the ordering of the hardware blocks in the mfd.
It's only used a few lines later to build resource addresses.

Thanks
/alessandro
