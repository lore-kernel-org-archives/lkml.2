Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2ACUja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:39:30 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:58756 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2ACUj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:39:28 -0500
Date: Tue, 3 Jan 2012 15:36:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>, Jan Beulich <JBeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Jens Axboe <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH, v2] Xen: consolidate and simplify struct xenbus_driver
 instantiation
Message-ID: <20120103203637.GF17472@phenom.dumpdata.com>
References: <4EF3018D020000780006986E@nat28.tlf.novell.com>
 <1324547820.7877.71.camel@zakaz.uk.xensource.com>
 <4EF327E2020000780006993E@nat28.tlf.novell.com>
 <1324555060.7877.84.camel@zakaz.uk.xensource.com>
 <1324565067.2897.2.camel@bwh-desktop>
 <1324586301.13113.3.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324586301.13113.3.camel@dagon.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F03673B.006D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 08:38:21PM +0000, Ian Campbell wrote:
> On Thu, 2011-12-22 at 14:44 +0000, Ben Hutchings wrote:
> > On Thu, 2011-12-22 at 11:57 +0000, Ian Campbell wrote:
> > > On Thu, 2011-12-22 at 11:51 +0000, Jan Beulich wrote:
> > > > >>> On 22.12.11 at 10:57, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> > > > > On Thu, 2011-12-22 at 09:08 +0000, Jan Beulich wrote:
> > > > >> The 'name', 'owner', and 'mod_name' members are redundant with the
> > > > >> identically named fields in the 'driver' sub-structure. Rather than
> > > > >> switching each instance to specify these fields explicitly, introduce
> > > > >> a macro to simplify this.
> > > > >> 
> > > > >> Eliminate further redundancy by allowing the drvname argument to
> > > > >> DEFINE_XENBUS_DRIVER() to be blank (in which case the first entry from
> > > > >> the ID table will be used for .driver.name).
> > > > > 
> > > > > Any reason not to always use DRV_NAME here (which is generally a bit
> > > > > more specific e.g. "xen-foofront" rather than "foo") and rely on the id
> > > > > table for the shorter names used in xenstore?
> > > > 
> > > > That would imply that DRV_NAME is always defined, but I don't
> > > > see this being the case.
> > > 
> > > My mistake, I thought it was a Kbuild thing.
> > 
> > You're maybe thinking of KBUILD_MODNAME.
> 
> Yes, I think I was.

Ian, are you OK with this patch? I think Jan needs to repost once more with the
"pciback" -> DRV_NAME change and then it is OK?

I've tested it with all backends, except the pciback one, and I see no regressions
with 'xl' or 'xm' toolstack.
