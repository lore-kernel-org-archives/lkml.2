Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab0JECoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 22:44:23 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:33013
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909Ab0JECoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 22:44:22 -0400
Date: Mon, 4 Oct 2010 20:45:29 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] DMI: log system, BIOS, and board information
Message-ID: <20101005024529.GA20805@helgaas.com>
References: <20100930164905.13154.33194.stgit@bob.kio>
 <20101004161926.7082bd13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004161926.7082bd13.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 04:19:26PM -0700, Andrew Morton wrote:
> On Thu, 30 Sep 2010 10:49:05 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > 
> > Put basic system information in the dmesg log.  There are lots of dmesg
> > logs on the web, and it would be useful if they contained this information
> > for debugging platform problems.
> > 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > ---
> > 
> >  drivers/firmware/dmi_scan.c |   35 ++++++++++++++++++++++++++++++++++-
> >  1 files changed, 34 insertions(+), 1 deletions(-)
> > 
> > 
> > diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> > index b3d22d6..d625e53 100644
> > --- a/drivers/firmware/dmi_scan.c
> > +++ b/drivers/firmware/dmi_scan.c
> > @@ -2,6 +2,7 @@
> >  #include <linux/string.h>
> >  #include <linux/init.h>
> >  #include <linux/module.h>
> > +#include <linux/ctype.h>
> >  #include <linux/dmi.h>
> >  #include <linux/efi.h>
> >  #include <linux/bootmem.h>
> > @@ -361,6 +362,36 @@ static void __init dmi_decode(const struct dmi_header *dm, void *dummy)
> >  	}
> >  }
> >  
> > +static const char * __init dmi_printable_system_info(int field)
> > +{
> > +	const char *info, *p;
> > +
> > +	info = dmi_get_system_info(field);
> > +	if (!info)
> > +		return NULL;
> > +
> > +	for (p = info; *p; p++)
> > +		if (!isprint(*p))
> > +			return "<...>";
> > +
> > +	return info;
> > +}
> 
> So if the string contains any non-printable character, we suppress the
> whole string.
> 
> Is that the best thing to do?  Would it be better to present the
> oddball character as \xNN or such?

I would definitely prefer to do that, but that would mean allocating
memory, and this happens so early that it looked like it would be
more trouble than it's worth.  I'm not saying I couldn't be convinced,
though.

Bjorn
