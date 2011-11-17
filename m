Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab1KQNli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:41:38 -0500
Received: from corega.com.ru ([195.178.208.66]:47000 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756744Ab1KQNlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 08:41:37 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Nov 2011 08:41:36 EST
Date: Thu, 17 Nov 2011 16:32:20 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Maciej Szmigiero <mhej@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christian Glindkamp <christian.glindkamp@taskit.de>,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH][W1]w1_therm: release the bus during conversion on
 externally powered devices
Message-ID: <20111117133220.GA28213@ioremap.net>
References: <4EC2F914.4010302@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC2F914.4010302@o2.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+gregkh

On Wed, Nov 16, 2011 at 12:43:16AM +0100, Maciej Szmigiero (mhej@o2.pl) wrote:
> w1_therm devices can either be bus powered or externally powered.
> 
> When device is bus powered during temperature conversion the bus
> have to be left high to provide necessary power. Some masters also allow
> strong power-up to be enabled in this case.
> Naturally, no communication over bus can occur during that time.
> 
> However, if device has external power then there is no such restriction,
> and host can talk to other devices during temperature conversion.
> 
> There is command which allows us to check how device is powered,
> this patch uses it to release the bus on externally w1_therm powered devices
> during temperature conversion.
> 
> Also, this changes uninterruptible sleeps there into interruptible ones to
> avoid long uninterruptible sleep if w1 subsystem happens to grab bus for
> scan during w1_therm_read().

Patch looks good, but I do not have such hardware to test it.
So, if it doesn't break things I'm ok to push it upstream.
Greg, please pull it into your tree, thank you.

> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
