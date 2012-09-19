Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2ISHTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:19:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35152 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab2ISHTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:19:47 -0400
Date: Wed, 19 Sep 2012 08:19:42 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Alex Lyashkov <umka@cloudlinux.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lve module taint?
Message-ID: <20120919071942.GF16905@kroah.com>
References: <87sjaepy67.fsf@rustcorp.com.au>
 <50595EF1.6050003@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50595EF1.6050003@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 09:58:09AM +0400, Michael Tokarev wrote:
> On 19.09.2012 06:02, Rusty Russell wrote:
> 
> > From:	Matthew Garrett <mjg59@srcf.ucam.org>
> > Subject: module: taint kernel when lve module is loaded
> > Date: Fri, 22 Jun 2012 13:49:31 -0400
> > 
> > Cloudlinux have a product called lve that includes a kernel module. This
> > was previously GPLed but is now under a proprietary license, but the
> > module continues to declare MODULE_LICENSE("GPL") and makes use of some
> > EXPORT_SYMBOL_GPL symbols. Forcibly taint it in order to avoid this.
> 
> > +	/* lve claims to be GPL but upstream won't provide source */
> > +	if (strcmp(mod->name, "lve") == 0)
> > +		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
> 
> This is setting a, in my opinion, rather bad precedent.  Next we'll
> be adding various modules here due to various reasons.
> 
> I think this case should be pure political now, not technical.  Ie,
> if some project declares itself as GPL, it is not kernel task to
> verify that the sources are available or to enforce that.

But when such code is known to lie, we have the responsibility to
enforce it, right?  We already do this for other module, it's not the
first time, and hopefully we will not have to continue extending this
"blacklist" to more modules, but real-world experience tends to make me
thing otherwise :(

Rusty, no objection from me for the patch.

thanks,

greg k-h
