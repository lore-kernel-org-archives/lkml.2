Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab1LVUi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:38:28 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:2593 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1LVUiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:38:24 -0500
X-IronPort-AV: E=Sophos;i="4.71,395,1320624000"; 
   d="scan'208";a="9642152"
Subject: Re: [PATCH, v2] Xen: consolidate and simplify struct xenbus_driver
 instantiation
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Jan Beulich <JBeulich@suse.com>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Jens Axboe <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <1324565067.2897.2.camel@bwh-desktop>
References: <4EF3018D020000780006986E@nat28.tlf.novell.com>
	 <1324547820.7877.71.camel@zakaz.uk.xensource.com>
	 <4EF327E2020000780006993E@nat28.tlf.novell.com>
	 <1324555060.7877.84.camel@zakaz.uk.xensource.com>
	 <1324565067.2897.2.camel@bwh-desktop>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Thu, 22 Dec 2011 20:38:21 +0000
Message-ID: <1324586301.13113.3.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 14:44 +0000, Ben Hutchings wrote:
> On Thu, 2011-12-22 at 11:57 +0000, Ian Campbell wrote:
> > On Thu, 2011-12-22 at 11:51 +0000, Jan Beulich wrote:
> > > >>> On 22.12.11 at 10:57, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> > > > On Thu, 2011-12-22 at 09:08 +0000, Jan Beulich wrote:
> > > >> The 'name', 'owner', and 'mod_name' members are redundant with the
> > > >> identically named fields in the 'driver' sub-structure. Rather than
> > > >> switching each instance to specify these fields explicitly, introduce
> > > >> a macro to simplify this.
> > > >> 
> > > >> Eliminate further redundancy by allowing the drvname argument to
> > > >> DEFINE_XENBUS_DRIVER() to be blank (in which case the first entry from
> > > >> the ID table will be used for .driver.name).
> > > > 
> > > > Any reason not to always use DRV_NAME here (which is generally a bit
> > > > more specific e.g. "xen-foofront" rather than "foo") and rely on the id
> > > > table for the shorter names used in xenstore?
> > > 
> > > That would imply that DRV_NAME is always defined, but I don't
> > > see this being the case.
> > 
> > My mistake, I thought it was a Kbuild thing.
> 
> You're maybe thinking of KBUILD_MODNAME.

Yes, I think I was.

Thanks,
Ian.


