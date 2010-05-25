Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab0EYP3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:29:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab0EYP3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:29:21 -0400
Date: Tue, 25 May 2010 07:58:02 -0700
From: Greg KH <gregkh@suse.de>
To: Martyn Welch <martyn.welch@ge.com>
Cc: nanakos@wired-net.gr, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vme: vme.c: fixed an EXPORT_SYMBOL warning
Message-ID: <20100525145802.GA6417@suse.de>
References: <1274792957-4602-1-git-send-email-nanakos@wired-net.gr>
 <20100525134453.GA4818@suse.de>
 <4BFBDC74.6000000@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFBDC74.6000000@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 03:19:32PM +0100, Martyn Welch wrote:
> Greg KH wrote:
> > On Tue, May 25, 2010 at 01:09:17PM +0000, nanakos@wired-net.gr wrote:
> >   
> >> From: Nanakos Chrysostomos <nanakos@wired-net.gr>
> >>
> >> Fixed an EXPORT_SYMBOL warning.
> >>     
> >
> > What type of warning?  a checkpatch.pl one?  a gcc one?  a sparse one?
> >
> > Please be more verbose.
> >
> >   
> >> Signed-off-by: Nanakos Chrysostomos <nanakos@wired-net.gr>
> >> ---
> >>  drivers/staging/vme/vme.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> >> index 093fbff..a0b63d5 100644
> >> --- a/drivers/staging/vme/vme.c
> >> +++ b/drivers/staging/vme/vme.c
> >> @@ -1519,7 +1519,6 @@ struct bus_type vme_bus_type = {
> >>  	.probe = vme_bus_probe,
> >>  	.remove = vme_bus_remove,
> >>  };
> >> -EXPORT_SYMBOL(vme_bus_type);
> >>  
> >>  static int __init vme_init(void)
> >>  {
> >> @@ -1530,6 +1529,7 @@ static void __exit vme_exit(void)
> >>  {
> >>  	bus_unregister(&vme_bus_type);
> >>  }
> >> +EXPORT_SYMBOL(vme_bus_type);
> >>     
> >
> > This does not look correct, why move this away from where the structure
> > is defined?
> >
> >   
> 
> It's a checkpatch error:
> 
> $ scripts/checkpatch.pl -f drivers/staging/vme/vme.c
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #1522: FILE: staging/vme/vme.c:1522:
> +EXPORT_SYMBOL(vme_bus_type);

We should fix checkpatch.pl, as this looks like a bug in it, not the
source code here.

thanks,

greg k-h
