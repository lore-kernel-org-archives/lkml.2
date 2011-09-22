Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1IVSEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:04:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab1IVSED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:04:03 -0400
Date: Thu, 22 Sep 2011 11:03:27 -0700
From: Greg KH <gregkh@suse.de>
To: Borislav Petkov <bp@alien8.de>
Cc: "Lucas C. Villa Real" <lucasvr@gmail.com>, linux-kernel@vger.kernel.org,
        Wey-Yi Guya <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] Initialize pointer on request_firmware
Message-ID: <20110922180327.GA1932@suse.de>
References: <20110921235515.7476c5fe.lucasvr@gmail.com>
 <20110922092347.GD17640@liondog.tnic>
 <20110922171829.GA4863@suse.de>
 <20110922175406.GA4709@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922175406.GA4709@gere.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 07:54:06PM +0200, Borislav Petkov wrote:
> On Thu, Sep 22, 2011 at 10:18:29AM -0700, Greg KH wrote:
> > On Thu, Sep 22, 2011 at 11:23:47AM +0200, Borislav Petkov wrote:
> > > On Wed, Sep 21, 2011 at 11:55:15PM -0300, Lucas C. Villa Real wrote:
> > > > Hello, folks,
> > > > 
> > > > I've seen some kernel oopses when suspending my machine. The problem comes from isight_firmware, which assumes that, on error, a call to request_firmware() will initialize the provided pointer to the firmware image to NULL.
> > > > 
> > > > The patch below fixes the isight_firmware side of the problem and also ensures that request_firmware() always sets the pointer to NULL on such cases (it currently does that for all except one situation).
> > > > 
> > > > Signed-off-by: Lucas C. Villa Real <lucasvr@gobolinux.org>
> > > > 
> > > > --- linux-3.0.4/drivers/base/firmware_class.c.orig	2011-09-21 21:03:01.000000000 -0300
> > > > +++ linux-3.0.4/drivers/base/firmware_class.c	2011-09-21 21:03:13.000000000 -0300
> > > > @@ -523,6 +523,7 @@ static int _request_firmware(const struc
> > > >  
> > > >  	if (WARN_ON(usermodehelper_is_disabled())) {
> > > >  		dev_err(device, "firmware: %s will not be loaded\n", name);
> > > > +		*firmware_p = NULL;
> > > >  		return -EBUSY;
> > > >  	}
> > > 
> > > Looks like f45f3c1f3f616 needs backporting to stable, if it hasn't
> > > happened yet.
> > 
> > What stable tree?  That patch was in the 2.6.36 release, so 3.0-stable
> > doesn't need it, right?
> 
> Judging by the diff lines above, 3.0.4 doesn't seem to have it. Wait,
> lemme check... uh no, I can't, the damn k.org thing is still down :-(.

The patch was in the 2.6.36 kernel, so by nature of that, 3.0 will also
have it, right?

> > > Oh, and then there's caca9510ff4e5 too which adds this
> > > exit path to the goto out label as the rest of the function.
> > 
> > But that was only due to other problems.
> 
> That second one adds the goto thing to the "out:" label where the
> firmware_p gets NULLed. IOW, it prepares the code for f45f3c1f3f616.
> 
> Does that make more sense now?

Nope, sorry, still confused :)

How about, what patches are needed for the 3.0-stable kernel tree in
order to resolve these issue?  Git commit ids please.

thanks,

greg k-h
