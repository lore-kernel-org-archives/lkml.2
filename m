Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1HXURw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:17:52 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58564 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613Ab1HXURu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:17:50 -0400
X-Sasl-enc: 5QAro5uwcM25x/xCGIz2kwlRyQ/kdXuyFsg3RBZ6zDtz 1314217070
Date: Wed, 24 Aug 2011 13:11:44 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Message-ID: <20110824201144.GA28667@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-3-git-send-email-kys@microsoft.com>
 <20110823224157.GA9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B236E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824025913.GC30779@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B27B9@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B27B9@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 04:46:11PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Tuesday, August 23, 2011 10:59 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
> > mod_devicetable.h
> > 
> > On Wed, Aug 24, 2011 at 12:44:38AM +0000, KY Srinivasan wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Greg KH [mailto:greg@kroah.com]
> > > > Sent: Tuesday, August 23, 2011 6:42 PM
> > > > To: KY Srinivasan
> > > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > > > Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
> > > > mod_devicetable.h
> > > >
> > > > On Fri, Jul 15, 2011 at 10:45:51AM -0700, K. Y. Srinivasan wrote:
> > > > > In preparation for implementing vmbus aliases for auto-loading
> > > > > Hyper-V drivers, define vmbus specific device ID.
> > > > >
> > > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > > ---
> > > > >  include/linux/mod_devicetable.h |    7 +++++++
> > > > >  1 files changed, 7 insertions(+), 0 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/mod_devicetable.h
> > > > b/include/linux/mod_devicetable.h
> > > > > index ae28e93..5a12377 100644
> > > > > --- a/include/linux/mod_devicetable.h
> > > > > +++ b/include/linux/mod_devicetable.h
> > > > > @@ -405,6 +405,13 @@ struct virtio_device_id {
> > > > >  };
> > > > >  #define VIRTIO_DEV_ANY_ID	0xffffffff
> > > > >
> > > > > +/*
> > > > > + * For Hyper-V devices we use the device guid as the id.
> > > > > + */
> > > > > +struct hv_vmbus_device_id {
> > > > > +	__u8 guid[16];
> > > > > +};
> > > >
> > > > Why do you not need a driver_data pointer here?  Are you sure you aren't
> > > > ever going to need it in the future?  Hint, I think you will...
> > >
> > > I am not sure I am following you here; the guid is the device ID and it is
> > > guaranteed to remain the same. What is the driver _data pointer here
> > > you are referring to here.  While some device id have the _data pointer,
> > > there are others that don't - for instance struct virtio_device_id. In
> > > our case, I am not sure how I would use this private pointer.
> > 
> > You use it like all other drivers use it, only if needed.
> 
> Fair enough; the point is I am not sure how I would use it.
> 
> > 
> > Hint, I think you need to use it in your hv_utils driver, it would
> > reduce the size of your code and simplify your logic.
> 
> Could you expand on this. Currently the util driver handles a bunch 
> services that have their own guids - and these have been included
> in the idtable. How would having the pointer simplify this code.

It would allow you, in your probe function, to do something different
depending on the guid that the probe function was matching on.  So you
would not have to check the guid again to do that, just use the data
pointed in that void pointer and away you go.

As an example, look at drivers/usb/class/cdc-acm.c, the acm_ids[]
variable which uses the driver_info field to contain a quirk for the
device.

> I looked at the usage of this in PCI and it appears to be for supporting
> dynamic  IDs for existing drivers.

No, that's exactly wrong.  dynamic ids play havoc with this pointer,
making some drivers not be able to handle dynamic ids because they rely
on it for some driver-specific information to be passed in it, which
dynamic ids can not handle.

Oh, have you remembered to turn off dynamic ids for these devices?  Or
do you support them properly?

greg k-h
