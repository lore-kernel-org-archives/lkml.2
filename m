Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab1HXDI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:08:57 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55443 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876Ab1HXDIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:08:31 -0400
X-Sasl-enc: NLZi5PstbQWYoaGGc0/642gu2y7NCEkIawzaeFWtGXBC 1314155310
Date: Tue, 23 Aug 2011 19:59:13 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Message-ID: <20110824025913.GC30779@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-3-git-send-email-kys@microsoft.com>
 <20110823224157.GA9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B236E@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B236E@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:44:38AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Tuesday, August 23, 2011 6:42 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
> > mod_devicetable.h
> > 
> > On Fri, Jul 15, 2011 at 10:45:51AM -0700, K. Y. Srinivasan wrote:
> > > In preparation for implementing vmbus aliases for auto-loading
> > > Hyper-V drivers, define vmbus specific device ID.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  include/linux/mod_devicetable.h |    7 +++++++
> > >  1 files changed, 7 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/include/linux/mod_devicetable.h
> > b/include/linux/mod_devicetable.h
> > > index ae28e93..5a12377 100644
> > > --- a/include/linux/mod_devicetable.h
> > > +++ b/include/linux/mod_devicetable.h
> > > @@ -405,6 +405,13 @@ struct virtio_device_id {
> > >  };
> > >  #define VIRTIO_DEV_ANY_ID	0xffffffff
> > >
> > > +/*
> > > + * For Hyper-V devices we use the device guid as the id.
> > > + */
> > > +struct hv_vmbus_device_id {
> > > +	__u8 guid[16];
> > > +};
> > 
> > Why do you not need a driver_data pointer here?  Are you sure you aren't
> > ever going to need it in the future?  Hint, I think you will...
> 
> I am not sure I am following you here; the guid is the device ID and it is 
> guaranteed to remain the same. What is the driver _data pointer here 
> you are referring to here.  While some device id have the _data pointer,
> there are others that don't - for instance struct virtio_device_id. In 
> our case, I am not sure how I would use this private pointer.

You use it like all other drivers use it, only if needed.

Hint, I think you need to use it in your hv_utils driver, it would
reduce the size of your code and simplify your logic.

And yes, not all bus types use it, but most do, for good reason.

greg k-h
