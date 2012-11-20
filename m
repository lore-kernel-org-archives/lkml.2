Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab2KTE4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:56:16 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:62364 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2KTE4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:56:14 -0500
Message-ID: <50AB0D6C.9040003@synaptics.com>
Date: Mon, 19 Nov 2012 20:56:12 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 02/06] input/rmi4: Core files
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com> <1353124734-16803-3-git-send-email-cheiny@synaptics.com> <20121117215415.GA5624@kroah.com>
In-Reply-To: <20121117215415.GA5624@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2012 01:54 PM, Greg Kroah-Hartman wrote:
> On Fri, Nov 16, 2012 at 07:58:50PM -0800, Christopher Heiny wrote:
>> +static void release_rmidev_device(struct device *dev)
>> +{
>> +	device_unregister(dev);
>> +}
>
> You just leaked memory here, right?
>
> Also, you already unregistered the device, otherwise this function would
> have never been called, so you just ended up in a loop?

Roger.  We'll fix that.


> Have you ever tried removing a device?  Are you sure it's working
> properly?

Hmmmm.  If it leads to the loop you mention above, then the test I'm 
using must not be doing what I thought it was.  I'll fix that, too.


>> +EXPORT_SYMBOL(rmi_register_phys_device);
>
> Just curious, but why not EXPORT_SYMBOL_GPL() on all of these new
> symbols you are creating?

We'll change that.

				Thanks very much!
						Chris
