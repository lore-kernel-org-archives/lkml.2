Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0CZNXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:23:12 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33263 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0CZNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:23:10 -0400
Date: Fri, 26 Mar 2010 13:23:18 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
Message-ID: <20100326122317.GC5387@hardeman.nu>
Mail-Followup-To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
References: <20091215115011.GB1385@ucw.cz>
 <4B279017.3080303@redhat.com>
 <20091215195859.GI24406@elf.ucw.cz>
 <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
 <20091215201933.GK24406@elf.ucw.cz>
 <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
 <20091215203300.GL24406@elf.ucw.cz>
 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
 <4BAB7659.1040408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BAB7659.1040408@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 11:42:33AM -0300, Mauro Carvalho Chehab wrote:
>>        2) add current_protocol support on other drivers;
> 
> Done. Patch were already merged upstream.
> 
> The current_protocol attribute shows the protocol(s) that the device is accepting
> and allows changing it to another protocol. 
> 
> In the case of the em28xx hardware, only one protocol can be active, since the decoder
> is inside the hardware. 
> 
> On the raw IR decode implementation I've done at the saa7134, all raw pulse events are
> sent to all registered decoders, so I'm thinking on using this sysfs node to allow
> disabling the standard behavior of passing the IR codes to all decoders, routing it
> to just one decoder.
> 
> Another alternative would be to show current_protocol only for devices with hardware
> decoder, and create one sysfs node for each decoder, allowing enabling/disabling each
> decoder individually.

You're eventually going to want to add ioctl's to set a lot of TX or RX 
parameters in one go (stuff like active receiver(s) and transmitter(s), 
carrier frequency, duty cycle, timeouts, filter levels and resolution - 
all of which would need to be set in one operation since some hardware 
will need to be reset after each parameter is changed).

Then you'll end up with a few things being controlled via sysfs and some 
being controlled via ioctls. Maybe it's a good idea to have a bitmask of 
supported and enabled protocols in those ioctls instead?

-- 
David Härdeman
