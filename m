Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1CBFre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:47:34 -0500
Received: from kroah.org ([198.145.64.141]:35695 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab1CBFrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:47:33 -0500
Date: Wed, 2 Mar 2011 00:39:20 -0500
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 3/6] Staging: hv: Cleanup hyperv_device variable names
Message-ID: <20110302053920.GA28382@kroah.com>
References: <1298685992-30864-1-git-send-email-kys@microsoft.com>
 <20110301024403.GD1663@kroah.com>
 <6E21E5352C11B742B20C142EB499E04801660E@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E04801660E@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 01:42:37AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Monday, February 28, 2011 9:44 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Hank
> > Janssen
> > Subject: Re: [PATCH 3/6] Staging: hv: Cleanup hyperv_device variable names
> > 
> > On Fri, Feb 25, 2011 at 06:06:32PM -0800, K. Y. Srinivasan wrote:
> > > Cleanup the names of variables that refer to the
> > > hyperv_device abstraction.
> > 
> > Clean them up to be what?  Shorter?  Nice?  Full of rounded edges so
> > that when we bump into them in the dark they don't poke us and cause us
> > to shreak in pain?
> > 
> > >
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > 
> > Sweet, you cloned yourself, I thought only Alan Cox had achieved that
> > goal...
> > 
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > >
> > > ---
> > >  drivers/staging/hv/blkvsc_drv.c  |   12 ++--
> > >  drivers/staging/hv/netvsc.c      |    4 +-
> > >  drivers/staging/hv/netvsc_drv.c  |   36 ++++----
> > >  drivers/staging/hv/storvsc_drv.c |   44 +++++-----
> > >  drivers/staging/hv/vmbus_drv.c   |  164 +++++++++++++++++++-----------------
> > --
> > >  5 files changed, 130 insertions(+), 130 deletions(-)
> > >
> > > diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> > > index 58ab0e8..305a665 100644
> > > --- a/drivers/staging/hv/blkvsc_drv.c
> > > +++ b/drivers/staging/hv/blkvsc_drv.c
> > > @@ -95,7 +95,7 @@ struct blkvsc_request {
> > >  /* Per device structure */
> > >  struct block_device_context {
> > >  	/* point back to our device context */
> > > -	struct hyperv_device *device_ctx;
> > > +	struct hyperv_device *device_obj;
> > 
> > Hey, I was right, it does have more rounded edges, nicely done.
> > 
> > 
> > > -static int netvsc_device_add(struct hyperv_device *device,
> > > -			void *additional_info);
> > > +static int
> > > +netvsc_device_add(struct hyperv_device *device, void *additional_info);
> > 
> > Again with the function return value hiding.  Please don't.
> > 
> > > --- a/drivers/staging/hv/storvsc_drv.c
> > > +++ b/drivers/staging/hv/storvsc_drv.c
> > > @@ -43,7 +43,7 @@ struct host_device_context {
> > >  	/* must be 1st field
> > >  	 * FIXME this is a bug */
> > >  	/* point back to our device context */
> > > -	struct hyperv_device *device_ctx;
> > > +	struct hyperv_device *device_obj;
> > 
> > I really don't understand this change at all.  "obj" is just as vapid
> > and clueless as "ctx" is, and it seems very gratuitous to change this.
> > And I should know, I have made a lot of gratuitous renames in my time in
> > the kernel...
> 
> Greg, there are not that many options here. As I recall there was universal
> objection to the use of  *context/*ctx to refer to device or driver objects.
> The name I chose is fairly descriptive of what it represents. If there is consensus 
> on a better name, I will  use it. 

Do it like other subsystems, call it a device with the prefix for the
type.  So for this one, it would be:
	struct hyperv_device *hyperv_device;
or
	struct hyperv_device *hyperv_dev;

> > Come on, global search-and-replace needs to be done in a sane manner,
> > other wise you can just send me a vi macro to run on the code, it would
> > be the same thing in the end (hint, don't do that, only one person has
> > ever gotten away with doing that in the history of the kernel, in an act
> > never to be ever repeated again.)
> 
> Greg, apart from your objection to the name I picked to refer to variable 
> referring to struct hyperv_device; what else is the problem here. 

Changing the comment that should be removed instead.

thanks,

greg k-h
