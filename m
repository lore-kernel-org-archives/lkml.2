Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1HHSEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:04:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37130 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1HHSEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:04:20 -0400
X-Sasl-enc: LWZy6GN8Sv5J1/qkau3lJpHD5kBhisMNjj9SLje5qCfS 1312826659
Date: Mon, 8 Aug 2011 11:04:00 -0700
From: Greg KH <greg@kroah.com>
To: "Emilio G. Cota" <cota@braap.org>, Martyn Welch <martyn.welch@ge.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110808180400.GA17257@kroah.com>
References: <4E3B9FA2.3060303@ge.com>
 <20110805090416.GA4806@becoht-mvanga>
 <4E3BB6E7.6020809@ge.com>
 <20110805174728.GA1741@flamenco.cs.columbia.edu>
 <4E3F97EA.2020600@ge.com>
 <20110808091432.GA19570@flamenco.cs.columbia.edu>
 <4E3FABDA.8080204@ge.com>
 <20110808101140.GA21300@flamenco.cs.columbia.edu>
 <4E3FC33D.2080202@ge.com>
 <20110808172216.GA2311@flamenco.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110808172216.GA2311@flamenco.cs.columbia.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 01:22:16PM -0400, Emilio G. Cota wrote:
> On Mon, Aug 08, 2011 at 12:06:37 +0100, Martyn Welch wrote:
> > On 08/08/11 11:11, Emilio G. Cota wrote:
> > > On Mon, Aug 08, 2011 at 10:26:50 +0100, Martyn Welch wrote:
> > >> On 08/08/11 10:14, Emilio G. Cota wrote:
> > >>> Martyn, no one in the kernel is doing what you propose, for
> > >>> good reason. Look at USB, PCI, RapidIO.  They all provide get
> > >>> and put functions to be called from probe and release.
> > >>
> > >> Really, which functions are these for PCI?
> > > 
> > > pci_get_dev/put in drivers/pci/pci-driver.c.
> > > 
> > 
> > Which isn't explicitly used by the vast majority of PCI drivers. In fact the
> > instances which I did find where this was used by a PCI device driver, it
> > appears to be using the old-style PCI probing.
> 
> > This is taken care of automatically for drivers using the "newer" PCI driver
> > registration model as part of the probe.

All PCI drivers are using that model, it is not "new" at all (5+ years
old now.)

The fact is, if you grab a pointer to a device, and save it somewhere,
you HAVE TO grab a reference to that object at the same time.

To not do so is a bug, and must be fixed.

It's that simple.

greg k-h
