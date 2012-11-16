Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2KPSAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:00:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45719 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab2KPSAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:00:51 -0500
Date: Fri, 16 Nov 2012 10:00:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, jens.taprogge@taprogge.org,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH] ipack: move header files to include/linux
Message-ID: <20121116180047.GA5078@kroah.com>
References: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
 <20121116174410.GA2143@kroah.com>
 <1353088114.4563.49.camel@fourier.local.igalia.com>
 <1353088388.4563.52.camel@fourier.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353088388.4563.52.camel@fourier.local.igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 06:53:08PM +0100, Samuel Iglesias Gonsálvez wrote:
> On Fri, 2012-11-16 at 18:48 +0100, Samuel Iglesias Gonsálvez wrote:
> > On Fri, 2012-11-16 at 09:44 -0800, Greg Kroah-Hartman wrote:
> > > On Fri, Nov 16, 2012 at 06:34:36PM +0100, Samuel Iglesias Gonsalvez wrote:
> > > > Move ipack header files to include/linux/ directory where they belong to.
> > > > 
> > > > Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> > > > ---
> > > >  drivers/ipack/carriers/tpci200.h |    3 +-
> > > >  drivers/ipack/devices/ipoctal.c  |    2 +-
> > > >  drivers/ipack/ipack.c            |    2 +-
> > > >  drivers/ipack/ipack.h            |  215 --------------------------------------
> > > >  drivers/ipack/ipack_ids.h        |   32 ------
> > > >  include/linux/ipack.h            |  214 +++++++++++++++++++++++++++++++++++++
> > > >  include/linux/ipack_ids.h        |   32 ++++++
> > > >  7 files changed, 249 insertions(+), 251 deletions(-)
> > > >  delete mode 100644 drivers/ipack/ipack.h
> > > >  delete mode 100644 drivers/ipack/ipack_ids.h
> > > >  create mode 100644 include/linux/ipack.h
> > > >  create mode 100644 include/linux/ipack_ids.h
> > > 
> > > Can you send me a patch in -M format, that just shows the files moving
> > > next time?
> > 
> > OK
> > 
> > > Also, do we really need the ipack_ids.h file in include/linux?  It looks
> > > like only the core ipack code cares about the values there, right?
> > > 
> > 
> > Yes, you are right. I will rewrite the patch again and send it.
> 
> Looking at the code, 'drivers/ipack/devices/ipoctal.c' needs
> IPACK1_DEVICE_ID_SBS_OCTAL_* and IPACK_ID_VERSION_1 constants defined in
> ipack_ids.h file.
> 
> Is it better to keep ipack_ids.h file in include/linux/ or change the
> #include sentence?

Hm, why are these two separate .h files anyway?  Why not just merge them
together, to make it simpler for an ipack driver to be written.  That
way they only have to worry about including one .h file :)

thanks,

greg k-h
