Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0HXACZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:02:25 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:13390 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021Ab0HXACX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:02:23 -0400
Message-ID: <000401cb431f$a06d83d0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Greg KH" <gregkh@suse.de>
Cc: "Morinaga" <morinaga526@dsn.okisemi.com>, <margie.foster@intel.com>,
        <alan@linux.intel.com>, <arjan@linux.intel.com>,
        <andrew.chih.howe.khor@intel.com>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, "LKML" <linux-kernel@vger.kernel.org>,
        <meego-dev@meego.com>
References: <4C6BA385.80409@dsn.okisemi.com> <20100818131401.GA5861@suse.de> <000601cb3f99$8f5a0a20$66f8800a@maildom.okisemi.com> <20100819152214.GD2562@suse.de> <000401cb42bf$07e201f0$66f8800a@maildom.okisemi.com> <20100823153449.GA18649@suse.de>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Date: Tue, 24 Aug 2010 09:02:19 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Greg KH" <gregkh@suse.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Morinaga" <morinaga526@dsn.okisemi.com>; <margie.foster@intel.com>; <alan@linux.intel.com>;
<arjan@linux.intel.com>; <andrew.chih.howe.khor@intel.com>; <qi.wang@intel.com>; <yong.y.wang@intel.com>; "LKML"
<linux-kernel@vger.kernel.org>; <meego-dev@meego.com>
Sent: Tuesday, August 24, 2010 12:34 AM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35


> On Mon, Aug 23, 2010 at 09:30:51PM +0900, Masayuki Ohtake wrote:
> > ----- Original Message ----- 
> > From: "Greg KH" <gregkh@suse.de>
> > To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
> > Cc: <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; <yong.y.wang@intel.com>; <qi.wang@intel.com>;
> > <andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <alan@linux.intel.com>; <margie.foster@intel.com>;
> > "Morinaga" <morinaga526@dsn.okisemi.com>
> > Sent: Friday, August 20, 2010 12:22 AM
> > Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
> >
> >
> > > On Thu, Aug 19, 2010 at 09:25:03PM +0900, Masayuki Ohtake wrote:
> > > > Please find <MASA>
> > >
> > > If someone takes the time to review your code and ask questions, it is
> > > considered common courtesy to at least answer them all and not ignore
> > > some of them.  Please do so.
> > >
> > > > > >  drivers/misc/Kconfig    |    9 +
> > > > > >  drivers/misc/Makefile   |    1 +
> > > > > >  drivers/misc/pch_phub.c |  722 +++++++++++++++++++++++++++++++++++++++++++++++
> > > > > >  3 files changed, 732 insertions(+), 0 deletions(-)
> > > > > >  create mode 100755 drivers/misc/pch_phub.c
> > > > >
> > > > > You forgot to add documentation for your sysfs files in
> > > > > Documentation/ABI/ which is a requiremend when you add new ones.
> > > >
> > > > <MASA>
> > > > Which folder should we put stable/ or testing/ ?
> > >
> > > Which do you feel it should be in?
> > I think 'testing' is appropriate.
>
> Ok, when will you feel they should move to "stable"?

After accepted by upstream and updating given comments,
we will move to stable.

>
> > > > > > +};
> > > > > > +
> > > > > > +/* SROM SPEC for MAC address assignment offset */
> > > > > > +static const int pch_phub_mac_offset[ETH_ALEN] = {0x3, 0x2, 0x1, 0x0, 0xb, 0xa};
> > > > > > +
> > > > > > +static DEFINE_MUTEX(pch_phub_mutex);
> > > > > > +static struct pch_phub_reg pch_phub_reg;
> > > > >
> > > > > So you can only have one of these devices in a system at the same time?
> > > > > What happens when a machine ships with two of them?
> > > >
> > > > <MASA>
> > > > I can't understand the above questioin meaning.
> > > > Give me more information, please.
> > > > What's does the above "these devices" mean?
> > >
> > > The device the driver is controlling.  What happens when this driver
> > > runs on a system that has 2 of these devices?  You need to be able to
> > > handle multiple devices, and that doesn't happen with a single variable,
> > > right?  Please dynamically allocate it and make the lock associated to
> > > the actual device, not the whole driver, if possible.
> > I can understand your saying.
> > But our driver for Topcliff doesn't support multiple device but single device only.
> > From LSI structure point of view, I think, it is impossible that
> > topcliff is used as multiple devices.
>
> Are you sure that this is going to be true?
>
> > None the less, should our driver support multiple device ?
>
> Yes, it is trivial to make it support multiple devices, which makes it
> easier in the future if you happen to have a machine with more than one.
I understand. You are right.
I will modify for supporting multiple devices.

Thanks, Ohtake(OKISEMI)


