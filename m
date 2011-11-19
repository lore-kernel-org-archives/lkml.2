Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1KSTGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:06:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab1KSTGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:06:41 -0500
Date: Sat, 19 Nov 2011 11:05:59 -0800
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, greg@kroah.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, roman-vl@meta.ua,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [17/26] b43: refuse to load unsupported firmware
Message-ID: <20111119190559.GC30197@suse.de>
References: <20111119000329.419617905@clark.kroah.org>
 <1321723330.2885.145.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1321723330.2885.145.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 05:22:10PM +0000, Ben Hutchings wrote:
> On Fri, 2011-11-18 at 16:02 -0800, Greg KH wrote:
> > 3.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > [This patch is supposed to be applied in 3.1 (and maybe older) branches only.]
> > 
> > New kernels support newer firmware that users may try to incorrectly use
> > with older kernels. Display error and explain the problem in such a case
> > 
> > Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/net/wireless/b43/main.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > --- a/drivers/net/wireless/b43/main.c
> > +++ b/drivers/net/wireless/b43/main.c
> > @@ -2508,6 +2508,13 @@ static int b43_upload_microcode(struct b
> >  		b43_print_fw_helptext(dev->wl, 1);
> >  		err = -EOPNOTSUPP;
> >  		goto error;
> > +	} else if (fwrev >= 598) {
> > +		b43err(dev->wl, "YOUR FIRMWARE IS TOO NEW. Support for "
> > +		       "firmware 598 and up requires kernel 3.2 or newer. You "
> > +		       "have to install older firmware or upgrade kernel.\n");
> > +		b43_print_fw_helptext(dev->wl, 1);
> > +		err = -EOPNOTSUPP;
> > +		goto error;
> [...]
> 
> Again, I strongly object to this way of handling the incompatibility.
> The revision check is fine, but the solution must be to assign a
> different filename for the newer revisions.  The changes to 3.0/3.1
> should be deferred until this is resolved.

You can object, however the driver author and maintainer wants it done
this way for now, so that's a valid solution that I have to accept.  It
solves real bugs that people have already hit when running the 3.0 and
3.1 kernels.  Propagating a userspace tool change for those systems
would be much harder, if not impossible, don't you think?  It would also
require a much more intrusive change to the driver infrastructure to
handle such a proposed change.

thanks,

greg k-h
