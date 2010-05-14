Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab0ENVEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:04:44 -0400
Received: from kroah.org ([198.145.64.141]:47908 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758419Ab0ENVEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:04:42 -0400
Date: Fri, 14 May 2010 13:50:23 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Mark <reodge@gmail.com>, gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Bernd Porr <berndporr@f2s.com>,
       Gorskin Ilya <revent82@gmail.com>
Subject: Re: [PATCH 2/2] Staging: comedi: Fixed more long line lengths in
 comedi.h
Message-ID: <20100514205023.GA23779@kroah.com>
References: <1273746519-4590-1-git-send-email-reodge@gmail.com>
 <1273746519-4590-2-git-send-email-reodge@gmail.com>
 <1273747232.21514.22.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273747232.21514.22.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 03:40:32AM -0700, Joe Perches wrote:
> On Thu, 2010-05-13 at 18:28 +0800, Mark wrote:
> > I'd like to get some feedback on this patch, since I'm not sure this is the best
> > way to fix the long line lengths. 
> > ---
> >  drivers/staging/comedi/comedi.h |   15 ++++++++++-----
> >  1 files changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
> > index 3e3663f..ea96a83 100644
> > --- a/drivers/staging/comedi/comedi.h
> > +++ b/drivers/staging/comedi/comedi.h
> > @@ -267,7 +267,8 @@
> >  		 * streaming input/output */
> >  		INSN_CONFIG_GET_HARDWARE_BUFFER_SIZE = 2006,
> >  		INSN_CONFIG_SET_COUNTER_MODE = 4097,
> > -		INSN_CONFIG_8254_SET_MODE = INSN_CONFIG_SET_COUNTER_MODE,	/* deprecated */
> > +		/* deprecated */
> 
> 			/* INSN_CONFIG_8254_SET_MODE is deprecated */

Yes, please change this to be like this.

> > -	static inline unsigned NI_CDIO_SCAN_BEGIN_SRC_RTSI(unsigned rtsi_channel)
> > +	static inline unsigned
> > +		NI_CDIO_SCAN_BEGIN_SRC_RTSI(unsigned rtsi_channel)
> >  	{
> >  		return NI_USUAL_RTSI_SELECT(rtsi_channel);
> >  	}
> 
> It'd be better to start the functions in column 1
> 
> static inline unsigned int NI_CDIO_SCAN_BEGIN_RTSI(unsigned int rtsi_channel)
> {
> 	return NI_USUAL_RTSI_SELECT(rtsi_channel);
> }

Hm, yes, that would fix most of the problems in this file.  Mark, care
to do this instead?

thanks,

greg k-h
