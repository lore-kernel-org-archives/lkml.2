Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2AEPxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:53:48 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34556 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932645Ab2AEPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:53:47 -0500
X-Sasl-enc: 4OiIVFsKv+AGd76K44lZ6j+II77Z2LEFYdR9x4kMZ+Y8 1325778825
Date: Thu, 5 Jan 2012 07:53:09 -0800
From: Greg KH <greg@kroah.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the battery tree
Message-ID: <20120105155309.GA4765@kroah.com>
References: <20120105144042.4e03850089cce56a7e9312e4@canb.auug.org.au>
 <20120105152536.GB28629@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105152536.GB28629@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 07:25:36PM +0400, Anton Vorontsov wrote:
> On Thu, Jan 05, 2012 at 02:40:42PM +1100, Stephen Rothwell wrote:
> > Hi Anton,
> > 
> > After merging the battery tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > ERROR: "sysfs_create_link_nowarn" [drivers/power/power_supply.ko] undefined!
> > 
> > Caused by commit 8351665195ce ("power_supply: allow a power supply to
> > explicitly point to powered device").  That symbol is not exported to
> > modules.
> > 
> > I have used the battery tree from next-20120104 for today.
> 
> Thanks for catching this, Stephen!
> 
> I wonder why do we need to use _nowarn variant?..
> 
> Something tells me that we actually want a warning.

Yes, no one other than the driver core should ever be calling this
function, that is why it is not exported.

And I'm guessing, hopefully, that this sysfs link you are creating, is
also being documented in Documentation/ABI/ right?  If not, it must be.

thanks,

greg k-h
