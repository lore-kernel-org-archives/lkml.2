Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab0EDODM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:03:12 -0400
Received: from kroah.org ([198.145.64.141]:49537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab0EDODK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:03:10 -0400
Date: Tue, 4 May 2010 07:03:36 -0700
From: Greg KH <greg@kroah.com>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated
	pages
Message-ID: <20100504140336.GA32393@kroah.com>
References: <20100503170449.GA31336@kroah.com> <65027.33303.qm@web94905.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65027.33303.qm@web94905.mail.in2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 12:16:44AM +0530, Pavan Savoy wrote:
> 
> 
> --- On Mon, 3/5/10, Greg KH <greg@kroah.com> wrote:
> 
> > From: Greg KH <greg@kroah.com>
> > Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated pages
> > To: "Tomas Winkler" <tomas.winkler@intel.com>
> > Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org, "David Woodhouse" <dwmw2@infradead.org>, "Kay Sievers" <kay.sievers@vrfy.org>, "David Woodhouse" <David.Woodhouse@intel.com>, "Johannes Berg" <johannes@sipsolutions.net>, "Ming Lei" <tom.leiming@gmail.com>, "Catalin Marinas" <catalin.marinas@arm.com>
> > Date: Monday, 3 May, 2010, 10:34 PM
> > On Sun, May 02, 2010 at 11:21:21AM
> > +0300, Tomas Winkler wrote:
> > > From: David Woodhouse <David.Woodhouse@intel.com>
> > > 
> > > fix memory leak introduced by the patch 6e03a201bbe:
> > > firmware: speed up request_firmware()
> > > 
> > > 1. vfree won't release pages there were allocated
> > explicitly and mapped
> > > using vmap. The memory has to be vunmap-ed and the
> > pages needs
> > > to be freed explicitly
> > > 
> > > 2. page array is moved into the 'struct
> > > firmware' so that we can free it from
> > release_firmware()
> > > and not only in fw_dev_release()
> > > 
> > > The fix doesn't break the firmware load speed.
> > > 
> > > Cc: Johannes Berg <johannes@sipsolutions.net>
> > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > Cc: Ming Lei <tom.leiming@gmail.com>
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Singed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > > ---
> > > V2: fix authorship of the patch
> > > V3: fix const struct firmware breakage
> > 
> > Thanks, this looks much better, I've applied it now.
> 
> Sorry to bump-in the middle.
> But as a user of firmware class, what should now my fw_entry structure be?
> const struct firmware *fw_entry or,
> struct firmware *fw_entry - without the const ..

You should leave it to be whatever it was before this patch, it has not
changed anything now.

thanks,

greg k-h
