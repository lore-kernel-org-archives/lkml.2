Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509Ab2KAN77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:59:59 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:41722 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756011Ab2KAN74 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:59:56 -0400
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=iso-8859-1
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121101135148.382aec00@pyramind.ukuu.org.uk>
Date: Thu, 1 Nov 2012 15:59:50 +0200
Cc: <balbi@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
References: <20121031212639.GQ12739@atomide.com> <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com> <20121031221402.GA29490@arwen.pp.htv.fi> <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com> <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com> <20121101110418.GF410@arwen.pp.htv.fi> <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com> <20121101124025.GA12489@arwen.pp.htv.fi> <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com> <20121101131609.GC12489@arwen.pp.htv.fi> <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com> <20121101135148.382aec00@pyramind.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Nov 1, 2012, at 3:51 PM, Alan Cox wrote:

>> What they want, and what every user wants, is I plug this board in, and
>> the driver make sure everything is loaded and ready. No, the end users
>> don't want to see any of the implementation details of how the bitfile
>> is transported; the driver can handle it.
> 
> That doesn't necessarily make it a bus merely some kind of hotplug
> enumeration of devices. That should all work properly both for devices
> and busses with spi and i²c as the final bits needed for it got fixed
> some time ago.
> 
> In an ideal world you don't want to be writing custom drivers for stuff.
> If your cape routes an i²c serial device to the existing system i²c
> busses then you want to just create an instance of any existing driver on
> the existing i²c bus not create a whole new layer of goop.
> 
> It does need to do the plumbing and resource management for the plumbing
> but thats not the same as being a bus.
> 
> Alan


Fair enough. But there's no such thing a 'hotplug enumeration construct' in Linux 
yet, and a bus is the closest thing to it. It does take advantage of the nice
way device code matches drivers and devices though.

I'm afraid that having the I2C/SPI drivers doing the detection won't work.
The capes can have arbitrary I2C/SPI devices (and even more weird components).
There is no way to assure for example that the I2C device responding to address 'foo'
in cape A is the same I2C device responding to the same address in cape B.

In a nutshell, no, I'm not writing any custom drivers for the stuff that exists
already. There is no extra layer after the device is created and operates as it was
located in the proper place in the DTS.

The custom drivers are only needed for complex capes where you can't
have the device simply work by creating the devices.

Regards

-- Pantelis




