Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1CKVwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:52:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:40163 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab1CKVwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:52:42 -0500
Subject: Re: RFC: Platform data for onboard USB assets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: andy.green@linaro.org
Cc: Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <4D79F068.2080009@linaro.org>
References: <4D79F068.2080009@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Mar 2011 08:52:36 +1100
Message-ID: <1299880356.22236.640.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-11 at 09:50 +0000, Andy Green wrote:
> Hi -
> 
> platform_data is a well established way in Linux to pass configuration 
> data up to on-board assets from a machine file like mach-xyz.c.  It's 
> also supported to pass platform_data up to devices that are probed 
> asynchronously from busses like i2c as well, which is very handy.

 .../...

That looks like something the device-tree would deal with nicely :-)

Cheers,
Ben.

> However AFAIK it's not possible to bind platform_data to probed USB 
> devices as it stands.
> 
> There are now boards which have on-board USB assets, for example OMAP4 
> Panda which has a USB <-> Ethernet bridge wired up permanently.  It'd be 
> convenient to also be able to pass optional platform_data to these 
> devices when they are asynchronously probed.
> 
> So what's the feeling about a new api to register an array of 
> platform_data pointers bound to static "devpath" names in the machine file?
> 
> When a usb device is instantiated, it can check through this array if it 
> exists, matching on devname, and attach the platform_data to the 
> underlying probed usb device's dev->platform_data, which it seems is 
> currently unused.
> 
> The particular use that suggested this is on Panda, it would be ideal to 
> be able to set a flag in the usb device's platform data that forces it 
> to be named eth%d since it's a hardwired asset on the board with an RJ45 
> socket.
> 
> Comments, implementation suggestions, enquiries as to my level of crack 
> consumption etc welcomed ^^
> 
> -Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


