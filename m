Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1BWW6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:58:36 -0500
Received: from mail3.microsoft.com ([131.107.115.214]:13409 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1BWW6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:58:35 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 1/4] staging: hv: Fix the code depending on struct
 vmbus_driver_context data order
Thread-Topic: [PATCH 1/4] staging: hv: Fix the code depending on struct
 vmbus_driver_context data order
Thread-Index: AQHL05XWnCH/uKEYB0+G8SDuaAyFhZQQH60A//+HfsCAAI9ZgP//eo4w
Date: Wed, 23 Feb 2011 22:58:33 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048014F5A@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
 <20110223212644.GC23766@kroah.com>
 <6E21E5352C11B742B20C142EB499E048014F2C@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110223224829.GA7175@kroah.com>
In-Reply-To: <20110223224829.GA7175@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.73]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, February 23, 2011 5:48 PM
> To: KY Srinivasan
> Cc: Haiyang Zhang; Hank Janssen; Abhishek Kane (Mindtree Consulting PVT LTD);
> gregkh@suse.de; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org
> Subject: Re: [PATCH 1/4] staging: hv: Fix the code depending on struct
> vmbus_driver_context data order
> 
> On Wed, Feb 23, 2011 at 10:44:37PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Wednesday, February 23, 2011 4:27 PM
> > > To: Haiyang Zhang
> > > Cc: Hank Janssen; KY Srinivasan; Abhishek Kane (Mindtree Consulting PVT
> LTD);
> > > gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org;
> > > virtualization@lists.osdl.org
> > > Subject: Re: [PATCH 1/4] staging: hv: Fix the code depending on struct
> > > vmbus_driver_context data order
> > >
> > > On Wed, Feb 23, 2011 at 12:19:55PM -0800, Haiyang Zhang wrote:
> > > > The patch fixed the code depending on the exact order of fields in the
> > > > struct vmbus_driver_context, so the unused field drv_ctx can be removed,
> > > > and drv_obj doesn't have to be the second field in this structure.
> > > >
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > > >
> > > > ---
> > > >  drivers/staging/hv/blkvsc_drv.c  |    2 ++
> > > >  drivers/staging/hv/netvsc_drv.c  |    2 ++
> > > >  drivers/staging/hv/storvsc_drv.c |    2 ++
> > > >  drivers/staging/hv/vmbus.h       |    2 +-
> > > >  drivers/staging/hv/vmbus_drv.c   |   14 +-------------
> > > >  5 files changed, 8 insertions(+), 14 deletions(-)
> > > >
> > > > diff --git a/drivers/staging/hv/blkvsc_drv.c
> b/drivers/staging/hv/blkvsc_drv.c
> > > > index 36a0adb..293ab8e 100644
> > > > --- a/drivers/staging/hv/blkvsc_drv.c
> > > > +++ b/drivers/staging/hv/blkvsc_drv.c
> > > > @@ -177,6 +177,8 @@ static int blkvsc_drv_init(int (*drv_init)(struct
> hv_driver
> > > *drv))
> > > >  	struct driver_context *drv_ctx = &g_blkvsc_drv.drv_ctx;
> > > >  	int ret;
> > > >
> > > > +	drv_ctx->hv_drv = &storvsc_drv_obj->base;
> > > > +
> > > >  	storvsc_drv_obj->ring_buffer_size = blkvsc_ringbuffer_size;
> > > >
> > > >  	/* Callback to client driver to complete the initialization */
> > > > diff --git a/drivers/staging/hv/netvsc_drv.c
> b/drivers/staging/hv/netvsc_drv.c
> > > > index 03f9740..364b6c7 100644
> > > > --- a/drivers/staging/hv/netvsc_drv.c
> > > > +++ b/drivers/staging/hv/netvsc_drv.c
> > > > @@ -500,6 +500,8 @@ static int netvsc_drv_init(int (*drv_init)(struct
> hv_driver
> > > *drv))
> > > >  	struct driver_context *drv_ctx = &g_netvsc_drv.drv_ctx;
> > > >  	int ret;
> > > >
> > > > +	drv_ctx->hv_drv = &net_drv_obj->base;
> > > > +
> > > >  	net_drv_obj->ring_buf_size = ring_size * PAGE_SIZE;
> > > >  	net_drv_obj->recv_cb = netvsc_recv_callback;
> > > >  	net_drv_obj->link_status_change = netvsc_linkstatus_callback;
> > > > diff --git a/drivers/staging/hv/storvsc_drv.c
> b/drivers/staging/hv/storvsc_drv.c
> > > > index a8427ff..33acee5 100644
> > > > --- a/drivers/staging/hv/storvsc_drv.c
> > > > +++ b/drivers/staging/hv/storvsc_drv.c
> > > > @@ -140,6 +140,8 @@ static int storvsc_drv_init(int (*drv_init)(struct
> hv_driver
> > > *drv))
> > > >  	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
> > > >  	struct driver_context *drv_ctx = &g_storvsc_drv.drv_ctx;
> > > >
> > > > +	drv_ctx->hv_drv = &storvsc_drv_obj->base;
> > > > +
> > > >  	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
> > > >
> > > >  	/* Callback to client driver to complete the initialization */
> > > > diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
> > > > index 42f2adb..fd9d00f 100644
> > > > --- a/drivers/staging/hv/vmbus.h
> > > > +++ b/drivers/staging/hv/vmbus.h
> > > > @@ -30,8 +30,8 @@
> > > >
> > > >  struct driver_context {
> > > >  	struct hv_guid class_id;
> > > > -
> > > >  	struct device_driver driver;
> > > > +	struct hv_driver *hv_drv;
> > >
> > > If you have a pointer to hv_driver, why do you need a full 'struct
> > > device_driver' here?  That sounds really wrong.
> > >
> > > Actually, having 'struct device_driver' within a structure called
> > > "driver_context" seems wrong, this should be what 'struct hv_driver'
> > > really is, right?
> >
> > We could certainly use better names to describe the layering here:
> > Think of driver_context as a representation of a generic hyperV device
> > driver. So, this structure will embed the generic struct device_driver.
> 
> That's fine, and is what all other driver subsystems do.  But they name
> it correctly, unlike this subsystem :)
>

 
We will get there!

> > The pointer to hv_drv allows for further specialization based on
> > the device type. For instance the block driver has its own hv_driver while
> > the network driver has its own instance of hv_driver. I am not defending
> > this layering, and I agree we could name these abstractions to be more
> > intuitive and also considerably improve the layering.
> 
> The layering is almost ok, there is still one more layer here than is
> needed, and it should be removed (I already removed lots of layers that
> were not needed, just didn't get to this one.)  But the naming also
> needs to be fixed up as it is wrong from a "driver model" standpoint
> with the rest of the kernel.

We will get rid of this additional layering. We could just as well embed the 
needed information. 

Regards,

K. Y  
> 
> thanks,
> 
> greg k-h

