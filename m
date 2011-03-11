Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1CKSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:09:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42965 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1CKSJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:09:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=fQ4JOFKsbNGKAwBee/jRcU4pB3bv7l3tf7FyhAIuE/n2vVlfOsEPPKdTuemfnmzuZB
         aEBbzsXZbs27oo8EMXUulNHzu5hRUhony+9FRkA7xeDdaRCd3o600a/L4NPU/3SGsZr+
         KLfdLefAuN7zfors9qX8kVst3oMax+dF/rNlo=
Message-ID: <4D7A654F.7010709@linaro.org>
Date: Fri, 11 Mar 2011 18:09:19 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <Pine.LNX.4.44L0.1103111141270.1975-100000@iolanthe.rowland.org> <4D7A5329.6080507@linaro.org> <20110311170807.GA10350@kroah.com>
In-Reply-To: <20110311170807.GA10350@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 05:08 PM, Somebody in the thread at some point said:
> On Fri, Mar 11, 2011 at 04:51:53PM +0000, Andy Green wrote:
>> On 03/11/2011 04:45 PM, Somebody in the thread at some point said:
>>
>> Hi -
>>
>>> Or to put it another way...  With external, hot-plugged USB devices,
>>> there is no need to know "how it is wired".  The fact that it is on a
>>> USB bus is the only information necessary.  Why does anyone need to
>>> know more than this for on-board USB devices?
>>
>> For example, the USB device is a chip with option pins.  On the
>> board it is placed on, some of the option pins are tied in a
>> particular way that impacts its actual function, but can't be seen
>> from the chip itself. The driver covers all the options, but it
>> needs to be told which mode the chip was wired up for.
>
> Then that information is in the driver that was written for that
> specific device, it is NOT a class device if it requires this type of
> information to work properly.

I don't believe I referred to class devices anywhere.  It does not 
matter if the main chip function is class device or not.

If there is any kind of "functional implementation" knowledge that is 
outside the chip and driver itself, it has to be held somewhere, and 
applied appropriately.  platform_data from the board definition file is 
the established place for that knowledge that is specific to a board.


An example of the same idea in a different context is OMAP4 I2C IP. 
There is a single I2C driver for all OMAP, and it adapts according to 
which revision of the IP it finds.  In the perfect case, the driver 
could thoroughly figure out what to do based on what it saw at runtime.

However different CPUs wired up their busses to these IP unit at 
different widths.  It meant according to that wiring topology 
information, you had to shift the register address by different amounts 
to access it.

Even though the driver had perfect domain knowledge of its IP core, 
there was some additional "functional configuration" knowledge that it 
HAD to be passed to succeed to operate correctly.  It could not infer 
this information from inside because this information was not in the 
configuration of the IP core itself.  The information described how the 
IP core "was wired".

They solve this by defining this cpu-specific information in 
cpu-specific files in the mach-omap2 dir and passing it up by platform_data.

> Also, do you have a real example of a USB driver today that needs this?

I think you find without devpath -> platform_data mapping, the kind of 
layout given above is made quite difficult to support in Linux.

Saying, "oh go away and do it in userspace" actually means special 
scripts that grep /proc/cpuinfo to reproduce the knowledge inherent 
already in the board definition file, although it's out of your hair 
nicely, it leaves me feeling we reached an overall solution that is 
"less good than it should be".

-Andy
