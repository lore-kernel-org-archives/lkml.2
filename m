Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab1CMBG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 20:06:57 -0500
Received: from kroah.org ([198.145.64.141]:47459 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab1CMBGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 20:06:54 -0500
Date: Sat, 12 Mar 2011 17:03:29 -0800
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async
 platform data to a dev path name
Message-ID: <20110313010329.GB20396@kroah.com>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com>
 <20110312223212.27020.9839.stgit@otae.warmcat.com>
 <201103130029.38458.rjw@sisk.pl>
 <4D7C0423.9020204@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7C0423.9020204@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 11:39:15PM +0000, Andy Green wrote:
> On 03/12/2011 11:29 PM, Somebody in the thread at some point said:
> 
> Hi -
> 
> >On Saturday, March 12, 2011, Andy Green wrote:
> >>This structure allows tagging arbitrary platform_data that can't be attached
> >>to a device until after it is probed, with the device path name that it is
> >>to be attached to.
> 
> >>+struct platform_async_platform_data {
> >>+	const char *device_path;
> >>+	void *platform_data;
> >>+};
> >>+
> >>  #endif /* _PLATFORM_DEVICE_H_ */
> >
> >Using device paths for this purpose seems to be very fragile to me.  Isn't
> >there any better solution?
> 
> Given that this targets board definition files which commonly do the
> platform_add_device for the USB bus controller synchronously, and
> the bus-connected devices it is aimed at are soldered on to the
> board connected to specific bus controllers, the bus paths are
> completely deterministic.

No they are not.

The physical layout is deterministic, but the bus number, and device
number, is not.  You are using the bus number here in this path, so that
is not going to work, sorry.

thanks,

greg k-h
