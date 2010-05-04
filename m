Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab0EDPrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:47:41 -0400
Received: from kroah.org ([198.145.64.141]:54924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab0EDPrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:47:40 -0400
Date: Tue, 4 May 2010 08:47:33 -0700
From: Greg KH <greg@kroah.com>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated
 pages
Message-ID: <20100504154733.GA24636@kroah.com>
References: <20100504140336.GA32393@kroah.com>
 <698815.43605.qm@web94909.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698815.43605.qm@web94909.mail.in2.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 08:07:33PM +0530, Pavan Savoy wrote:
> 
> --- On Tue, 4/5/10, Greg KH <greg@kroah.com> wrote:
> 
> > From: Greg KH <greg@kroah.com>
> > Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated pages
> > To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> > Cc: "Tomas Winkler" <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
> > Date: Tuesday, 4 May, 2010, 7:33 PM
> > On Tue, May 04, 2010 at 12:16:44AM
> > +0530, Pavan Savoy wrote:
> > > 
> > > 
> > > --- On Mon, 3/5/10, Greg KH <greg@kroah.com>
> > wrote:
> > > 
> > > > From: Greg KH <greg@kroah.com>
> > > > Subject: Re: [PATCH v3] firmware_class: fix
> > memory leak - free allocated pages
> > > > To: "Tomas Winkler" <tomas.winkler@intel.com>
> > > > Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
> > linux-kernel@vger.kernel.org,
> > "David Woodhouse" <dwmw2@infradead.org>,
> > "Kay Sievers" <kay.sievers@vrfy.org>,
> > "David Woodhouse" <David.Woodhouse@intel.com>,
> > "Johannes Berg" <johannes@sipsolutions.net>,
> > "Ming Lei" <tom.leiming@gmail.com>,
> > "Catalin Marinas" <catalin.marinas@arm.com>
> > > > Date: Monday, 3 May, 2010, 10:34 PM
> > > > On Sun, May 02, 2010 at 11:21:21AM
> > > > +0300, Tomas Winkler wrote:
> > > > > From: David Woodhouse <David.Woodhouse@intel.com>
> > > > > 
> > > > > fix memory leak introduced by the patch
> > 6e03a201bbe:
> > > > > firmware: speed up request_firmware()
> > > > > 
> > > > > 1. vfree won't release pages there were
> > allocated
> > > > explicitly and mapped
> > > > > using vmap. The memory has to be vunmap-ed
> > and the
> > > > pages needs
> > > > > to be freed explicitly
> > > > > 
> > > > > 2. page array is moved into the 'struct
> > > > > firmware' so that we can free it from
> > > > release_firmware()
> > > > > and not only in fw_dev_release()
> > > > > 
> > > > > The fix doesn't break the firmware load
> > speed.
> > > > > 
> > > > > Cc: Johannes Berg <johannes@sipsolutions.net>
> > > > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > > > Cc: Ming Lei <tom.leiming@gmail.com>
> > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > Singed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > > > > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > > > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > > > > ---
> > > > > V2: fix authorship of the patch
> > > > > V3: fix const struct firmware breakage
> > > > 
> > > > Thanks, this looks much better, I've applied it
> > now.
> > > 
> > > Sorry to bump-in the middle.
> > > But as a user of firmware class, what should now my
> > fw_entry structure be?
> > > const struct firmware *fw_entry or,
> > > struct firmware *fw_entry - without the const ..
> > 
> > You should leave it to be whatever it was before this
> > patch, it has not
> > changed anything now.
> 
> Ok, However this patch has changed the release_firmware,
> -release_firmware(const struct firmware *fw)
> +release_firmware(struct firmware *fw)

Does your code now complain about a warning?  If so, do you have a
pointer to it?

thanks,

greg k-h
