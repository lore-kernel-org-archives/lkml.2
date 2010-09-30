Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0I3GZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:25:10 -0400
Received: from kroah.org ([198.145.64.141]:53262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab0I3GZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:25:07 -0400
Date: Wed, 29 Sep 2010 23:20:27 -0700
From: Greg KH <greg@kroah.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/22] Staging: cx25821: Makefile:cleaned up
	makefile cflag lines
Message-ID: <20100930062027.GC8707@kroah.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com> <20100925102801.GA3450@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100925102801.GA3450@merkur.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 12:28:01PM +0200, Sam Ravnborg wrote:
> On Fri, Sep 24, 2010 at 07:27:49PM -0400, Tracey Dent wrote:
> > changed to use proper ccflags-y option
> > 
> > Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> > ---
> >  drivers/staging/cx25821/Makefile |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/staging/cx25821/Makefile b/drivers/staging/cx25821/Makefile
> > index d0eb16e..2f1c73e 100644
> > --- a/drivers/staging/cx25821/Makefile
> > +++ b/drivers/staging/cx25821/Makefile
> > @@ -7,7 +7,7 @@ cx25821-objs   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
> >  obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
> >  obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
> >  
> > -EXTRA_CFLAGS += -Idrivers/media/video
> > -EXTRA_CFLAGS += -Idrivers/media/common/tuners
> > -EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
> > -EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
> > +ccflags-y := -Idrivers/media/video
> > +ccflags-y := -Idrivers/media/common/tuners
> > +ccflags-y := -Idrivers/media/dvb/dvb-core
> > +ccflags-y := -Idrivers/media/dvb/frontends
> 
> This is wrong.
> 
> First you assign "ccflags-y" the value -Idrivers/media/video
> And in next line you assign it a new value - loosing the old value.
> 
> It should lok like this:
> > +ccflags-y := -Idrivers/media/video
> > +ccflags-y += -Idrivers/media/common/tuners
> > +ccflags-y += -Idrivers/media/dvb/dvb-core
> > +ccflags-y += -Idrivers/media/dvb/frontends
> 
> In this way you append to the variable.
> 
> You said in another mil that it builds.
> This tells me that either some of the assignments are not needes - or you just loose
> something that you are not aware of.
> 
> Please go through all your patches and fix it up - I saw the above
> bug in the two patches I looked at.

I agree, these need to be fixed up, care to redo the series and send
them again?

thanks,

greg k-h
