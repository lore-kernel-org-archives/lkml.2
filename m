Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1LVOoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:44:34 -0500
Received: from mail.solarflare.com ([216.237.3.220]:45969 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752615Ab1LVOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:44:33 -0500
Subject: Re: [PATCH, v2] Xen: consolidate and simplify struct xenbus_driver
 instantiation
From: Ben Hutchings <bhutchings@solarflare.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Jan Beulich <JBeulich@suse.com>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Jens Axboe <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <1324555060.7877.84.camel@zakaz.uk.xensource.com>
References: <4EF3018D020000780006986E@nat28.tlf.novell.com>
	 <1324547820.7877.71.camel@zakaz.uk.xensource.com>
	 <4EF327E2020000780006993E@nat28.tlf.novell.com>
	 <1324555060.7877.84.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 22 Dec 2011 14:44:27 +0000
Message-ID: <1324565067.2897.2.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18598.006
X-TM-AS-Result: No--22.548800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 11:57 +0000, Ian Campbell wrote:
> On Thu, 2011-12-22 at 11:51 +0000, Jan Beulich wrote:
> > >>> On 22.12.11 at 10:57, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> > > On Thu, 2011-12-22 at 09:08 +0000, Jan Beulich wrote:
> > >> The 'name', 'owner', and 'mod_name' members are redundant with the
> > >> identically named fields in the 'driver' sub-structure. Rather than
> > >> switching each instance to specify these fields explicitly, introduce
> > >> a macro to simplify this.
> > >> 
> > >> Eliminate further redundancy by allowing the drvname argument to
> > >> DEFINE_XENBUS_DRIVER() to be blank (in which case the first entry from
> > >> the ID table will be used for .driver.name).
> > > 
> > > Any reason not to always use DRV_NAME here (which is generally a bit
> > > more specific e.g. "xen-foofront" rather than "foo") and rely on the id
> > > table for the shorter names used in xenstore?
> > 
> > That would imply that DRV_NAME is always defined, but I don't
> > see this being the case.
> 
> My mistake, I thought it was a Kbuild thing.

You're maybe thinking of KBUILD_MODNAME.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

