Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab1CBBmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 20:42:39 -0500
Received: from mail3.microsoft.com ([131.107.115.214]:24907 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab1CBBmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 20:42:38 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 3/6] Staging: hv: Cleanup hyperv_device variable names
Thread-Topic: [PATCH 3/6] Staging: hv: Cleanup hyperv_device variable names
Thread-Index: AQHL1ViS3KVTojE7hESxh/U9QG1BvZQYUHiAgADlbFA=
Date: Wed, 2 Mar 2011 01:42:37 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E04801660E@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1298685992-30864-1-git-send-email-kys@microsoft.com>
 <20110301024403.GD1663@kroah.com>
In-Reply-To: <20110301024403.GD1663@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.72]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, February 28, 2011 9:44 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Hank
> Janssen
> Subject: Re: [PATCH 3/6] Staging: hv: Cleanup hyperv_device variable names
> 
> On Fri, Feb 25, 2011 at 06:06:32PM -0800, K. Y. Srinivasan wrote:
> > Cleanup the names of variables that refer to the
> > hyperv_device abstraction.
> 
> Clean them up to be what?  Shorter?  Nice?  Full of rounded edges so
> that when we bump into them in the dark they don't poke us and cause us
> to shreak in pain?
> 
> >
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Sweet, you cloned yourself, I thought only Alan Cox had achieved that
> goal...
> 
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> >
> > ---
> >  drivers/staging/hv/blkvsc_drv.c  |   12 ++--
> >  drivers/staging/hv/netvsc.c      |    4 +-
> >  drivers/staging/hv/netvsc_drv.c  |   36 ++++----
> >  drivers/staging/hv/storvsc_drv.c |   44 +++++-----
> >  drivers/staging/hv/vmbus_drv.c   |  164 +++++++++++++++++++-----------------
> --
> >  5 files changed, 130 insertions(+), 130 deletions(-)
> >
> > diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> > index 58ab0e8..305a665 100644
> > --- a/drivers/staging/hv/blkvsc_drv.c
> > +++ b/drivers/staging/hv/blkvsc_drv.c
> > @@ -95,7 +95,7 @@ struct blkvsc_request {
> >  /* Per device structure */
> >  struct block_device_context {
> >  	/* point back to our device context */
> > -	struct hyperv_device *device_ctx;
> > +	struct hyperv_device *device_obj;
> 
> Hey, I was right, it does have more rounded edges, nicely done.
> 
> 
> > -static int netvsc_device_add(struct hyperv_device *device,
> > -			void *additional_info);
> > +static int
> > +netvsc_device_add(struct hyperv_device *device, void *additional_info);
> 
> Again with the function return value hiding.  Please don't.
> 
> > --- a/drivers/staging/hv/storvsc_drv.c
> > +++ b/drivers/staging/hv/storvsc_drv.c
> > @@ -43,7 +43,7 @@ struct host_device_context {
> >  	/* must be 1st field
> >  	 * FIXME this is a bug */
> >  	/* point back to our device context */
> > -	struct hyperv_device *device_ctx;
> > +	struct hyperv_device *device_obj;
> 
> I really don't understand this change at all.  "obj" is just as vapid
> and clueless as "ctx" is, and it seems very gratuitous to change this.
> And I should know, I have made a lot of gratuitous renames in my time in
> the kernel...

Greg, there are not that many options here. As I recall there was universal
objection to the use of  *context/*ctx to refer to device or driver objects.
The name I chose is fairly descriptive of what it represents. If there is consensus 
on a better name, I will  use it. 

> 
> >  static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
> >  {
> > -	struct hyperv_device *device_ctx = device_to_hyperv_device(device);
> > +	struct hyperv_device *device_obj = device_to_hyperv_device(device);
> >  	int ret;
> >
> >  	DPRINT_INFO(VMBUS_DRV, "generating uevent -
> VMBUS_DEVICE_CLASS_GUID={"
> >  		    "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> >  		    "%02x%02x%02x%02x%02x%02x%02x%02x}",
> > -		    device_ctx->class_id.data[3], device_ctx->class_id.data[2],
> > -		    device_ctx->class_id.data[1], device_ctx->class_id.data[0],
> > -		    device_ctx->class_id.data[5], device_ctx->class_id.data[4],
> > -		    device_ctx->class_id.data[7], device_ctx->class_id.data[6],
> > -		    device_ctx->class_id.data[8], device_ctx->class_id.data[9],
> > -		    device_ctx->class_id.data[10],
> > -		    device_ctx->class_id.data[11],
> > -		    device_ctx->class_id.data[12],
> > -		    device_ctx->class_id.data[13],
> > -		    device_ctx->class_id.data[14],
> > -		    device_ctx->class_id.data[15]);
> > +		    device_obj->class_id.data[3], device_obj->class_id.data[2],
> > +		    device_obj->class_id.data[1], device_obj->class_id.data[0],
> > +		    device_obj->class_id.data[5], device_obj->class_id.data[4],
> > +		    device_obj->class_id.data[7], device_obj->class_id.data[6],
> > +		    device_obj->class_id.data[8], device_obj->class_id.data[9],
> > +		    device_obj->class_id.data[10],
> > +		    device_obj->class_id.data[11],
> > +		    device_obj->class_id.data[12],
> > +		    device_obj->class_id.data[13],
> > +		    device_obj->class_id.data[14],
> > +		    device_obj->class_id.data[15]);
> 
> After seeing this stuff so many times I'm waiting for a helper function
> to be added for it in this subsystem.  I'm sure you really don't want to
> edit GUID printk-like functions ever again, right?

I will have a separate patch for this.

> 
> >  static void vmbus_device_release(struct device *device)
> >  {
> > -	struct hyperv_device *device_ctx = device_to_hyperv_device(device);
> > +	struct hyperv_device *device_obj = device_to_hyperv_device(device);
> >
> > -	kfree(device_ctx);
> > +	kfree(device_obj);
> >
> > -	/* !!DO NOT REFERENCE device_ctx anymore at this point!! */
> > +	/* !!DO NOT REFERENCE device_obj anymore at this point!! */
> >  }
> 
> I think by virtue of the kfree() right above this comment, it should be
> deleted.  Especially as it is at the end of the function, making it
> pretty much impossible to make any sense here...

For what it is worth; this is existing code. In the spirit of one thing per patch;
there will be a patch for this.

> 
> Come on, global search-and-replace needs to be done in a sane manner,
> other wise you can just send me a vi macro to run on the code, it would
> be the same thing in the end (hint, don't do that, only one person has
> ever gotten away with doing that in the history of the kernel, in an act
> never to be ever repeated again.)

Greg, apart from your objection to the name I picked to refer to variable 
referring to struct hyperv_device; what else is the problem here. 

Regards,

K. Y 
 
> 
> thanks,
> 
> greg k-h

