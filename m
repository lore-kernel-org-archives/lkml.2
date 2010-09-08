Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0IHAiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:38:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:44669 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172Ab0IHAiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:38:02 -0400
Date: Tue, 7 Sep 2010 17:38:21 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: xgifb: Initialize uninitialized variables
Message-ID: <20100908003821.GC27719@suse.de>
References: <1283837645.6302.10.camel@lenovo> <4C85FBE3.4000605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C85FBE3.4000605@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 10:46:27AM +0200, Jiri Slaby wrote:
> On 09/07/2010 07:34 AM, Javier Martinez Canillas wrote:
> > Current patch solves compilation warnings in staging/xgifb for using possibly uninitialized variables.
> > 
> > Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> > ---
> >  drivers/staging/xgifb/vb_setmode.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
> > index c4db2fc..720a592 100644
> > --- a/drivers/staging/xgifb/vb_setmode.c
> > +++ b/drivers/staging/xgifb/vb_setmode.c
> > @@ -376,7 +376,7 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
> >  unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
> >  			unsigned short ModeNo)
> >  {
> > -	unsigned short ModeIdIndex;
> > +	unsigned short ModeIdIndex = 0;
> >  	/* unsigned char *pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress; */
> >  	struct vb_device_info VBINF;
> >  	struct vb_device_info *pVBInfo = &VBINF;
> 
> No, please don't. This is a compiler bug.
> 
> The first use in that function is:
> XGI_SearchModeID( ModeNo , &ModeIdIndex, pVBInfo );
> 
> and that function contains:
> if (XYZ) {
>   for( *ModeIdIndex = 0 ; ; ( *ModeIdIndex )++ )
>     ...
> } else {
>   for( *ModeIdIndex = 0 ; ; ( *ModeIdIndex )++ )
>     ...
> }
> 
> So your compiler is foolish if that emits a warning.

No, I don't see a way that the compiler could really figure that type of
logic out.  It doesn't know that XGI_SearchModeID() always will set that
field.  Heck, at first glance I couldn't even figure it out :)

So I don't mind applying this patch, as I'll just constantly keep
getting people sending me the same change, when they could be off
working on other things that this driver needs.

thanks,

greg k-h
