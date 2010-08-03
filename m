Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0HCBIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:08:39 -0400
Received: from kroah.org ([198.145.64.141]:54492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab0HCBIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:08:38 -0400
Date: Mon, 2 Aug 2010 18:05:59 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "ss@aao.gov.au" <ss@aao.gov.au>, "gregkh@suse.de" <gregkh@suse.de>
Subject: Re: [PATCH] Staging: dt3155: properly export the module parameter
Message-ID: <20100803010559.GA3814@kroah.com>
References: <201007280948.33247.hartleys@visionengravers.com>
 <4C509A18.3090607@gmail.com>
 <0D753D10438DA54287A00B027084269763743B4D7C@AUSP01VMBX24.collaborationhost.net>
 <4C517D80.6010106@gmail.com>
 <0D753D10438DA54287A00B027084269763743B552E@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269763743B552E@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 11:02:38AM -0500, H Hartley Sweeten wrote:
> On Thursday, July 29, 2010 6:09 AM, Jiri Slaby wrote:
> > On 07/29/2010 02:55 AM, H Hartley Sweeten wrote:
> >> On Wednesday, July 28, 2010 1:59 PM, Jiri Slaby wrote:
> >>> On 07/28/2010 06:48 PM, H Hartley Sweeten wrote:
> >>>> --- a/drivers/staging/dt3155/dt3155_drv.c
> >>>> +++ b/drivers/staging/dt3155/dt3155_drv.c
> >>>> @@ -99,7 +99,9 @@ wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
> >>>>  
> >>>>  /* set to dynamicaly allocate, but it is tunable: */
> >>>>  /* insmod DT_3155 dt3155 dt3155_major=XX */
> >>>> -int dt3155_major = 0;
> >>>> +static int dt3155_major;
> >>>> +module_param(dt3155_major, int, 0);
> >>>> +MODULE_PARM_DESC(dt3155_major, "Major device number");
> >>>
> >>> Is it necessary in the age of udev?
> >>>
> >>> I would personally get rid of that completely...
> >> 
> >> I agree but I'm not quite sure if the user space app is ready to handle that.
> >
> > Given it was never exposed as a parameter, applications should handle
> > that. 0 means allocate major dynamically...
> 
> Understood.
> 
> I finally found the "official" site for the "DT3155 Framegrabber Linux Device Driver"
> 
> http://sourceforge.net/projects/dt3155a/
> 
> The script provided to load the module does grep /proc/devices to determine the major
> device number and then mknod's the appropriate devices.
> 
> I will update my patch and remove the "parameter" since it is not needed.

As there is another driver already in the tree for this device,
dt3155v4l, I'm about to delete the dt3155 driver as it's no longer
needed.  So you might want to reconsider your work on this driver for
the near future.

thanks,

greg k-h
