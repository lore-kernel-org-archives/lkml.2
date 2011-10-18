Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab1JROFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:05:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab1JROFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:05:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
Date: Tue, 18 Oct 2011 16:05:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        jamie@jamieiles.com
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org> <20111017161854.GB5108@suse.de> <4E9D5FAB.2080605@linaro.org>
In-Reply-To: <4E9D5FAB.2080605@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110181605.12512.arnd@arndb.de>
X-Provags-ID: V02:K0:NoK5T4qsIOPolajQOve0nn4L4x4YFxqFkrlwfGYor76
 GPyFo0G9Q3Z2EtGp/Yo30eppXzodmHhR1jptumreq7h3bQspjh
 jZFuWdyDbhl4LyNRQWoFIa8l52LmoqapCH/o9HhGd1tqeNqHDH
 z4wxt/sGoB5jPR+ICaI4L6HKZZ552Uk4iLyXn3gv8arDCwiela
 QxLAoRbgyalhfQQ25CwgyhgtyGA3cyePnMbqDDgdmnx4x/bexz
 HhOUYyAtm2a2b0SZcA1+q7IXuUF/pEj946mjmYfa1UkTKRWQe3
 +3zacGnZ2yshjQYvcPQP2t1gqW4VGc0g56SoCOZEFSJtVT5T8/
 lm63S9QaJdGUWUvJBwzs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 October 2011, Lee Jones wrote:
> On 17/10/11 17:18, Greg KH wrote:
> > On Mon, Oct 17, 2011 at 12:52:54PM +0100, Lee Jones wrote:
> >> +{
> >> +	struct soc_device *soc_dev =
> >> +		container_of(dev, struct soc_device, dev);
> >> +
> >> +	sysfs_remove_group(&dev->kobj, &soc_attr_group);
> >> +
> >> +	if (device_is_registered(dev))
> >> +		device_unregister(dev);
> > 
> > Why is this call needed?
> 
> To unregister a previously unregistered device?
> 
> Is that wrong?

See Jamie's excellent explanation: you don't need to check
for device_is_registered() here, but just call device_unregister
unconditionally.

> >> +
> >> +	bus_unregister(&soc_bus_type);
> > 
> > What happens if you have more than one SOC device?  I think you just
> > oopsed.
> 
> I think you're right.
> 
> When to you suggest we unregister the bus?

Do it in the same way as registering it, as a module_exit() function
below the initcall that instantiates it. These interfaces usually come
in pairs, so if something does not look symmetric, you should better
have another look.

	Arnd
