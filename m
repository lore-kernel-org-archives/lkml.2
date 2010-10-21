Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab0JUM1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:27:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35088 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab0JUM1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:27:11 -0400
From: "Kanigeri, Hari" <h-kanigeri2@ti.com>
To: "Kamoolkar, Mugdha" <mugdha@ti.com>, "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "Kamat, Nishant" <nskamat@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Anna, Suman" <s-anna@ti.com>, Simon Que <sque@ti.com>
Date: Thu, 21 Oct 2010 07:26:25 -0500
Subject: RE: [PATCH 3/3] omap: add hwspinlock device
Thread-Topic: [PATCH 3/3] omap: add hwspinlock device
Thread-Index: ActwjBYZ42+jyHUzT/m0HqnV96vz7gAbk0dwAAfwZmA=
Message-ID: <8F7AF80515AF0D4D93307E594F3CB40E6E0DD10A@dlee03.ent.ti.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com>
 <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
 <87bp6pviwf.fsf@deeprootsystems.com>
 <AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
 <8739s0sobc.fsf@deeprootsystems.com>
 <AANLkTikdjtYtzhgM_=io3SFdUZq=8Xcc8n24bW=SFgTA@mail.gmail.com>
 <B85A65D85D7EB246BE421B3FB0FBB5930233F94602@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930233F94602@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mugdha,

> > >>
> > >> This does not require any smart IPC and it will allow us to get
> > rid of
> > >> the omap_hwspinlock_request_specific() API and its early-callers
> > >> requirement.
> > >
> > > Yes, that would indeed simplify things.
> >
> > Balaji, Nishant, are you OK with this ?
> >
> The problem with this approach is that the i2c driver would have to
> sync up on the shared memory location that it uses to share the
> information of the spinlock ID. What location would this be? How would
> the i2c driver on the m3 know about this location? Does this mean
> hard-coding of the shared memory address? If yes, then there would be
> an impact to users if they wanted to change their memory map. Any kind
> of hard-coding of this sort can be painful in such cases, especially
> if it happens in multiple drivers. On the other hand, hard-coding
> (reserving) spinlock IDs is a much safer option and does not impact
> anything else.
> 

We can avoid the hard-coding of shared memory location if I2C Driver maps using iommu some dynamic memory for shared memory location to M3 virtual address and shares this information to I2c driver counter-part on M3 using the IPC call. But this might not be trivial and this would be against what Ohad mentioned about not requiring any smart IPC :).
I prefer hard-coding of spinlock id to keep things simple.

Thank you,
Best regards,
Hari
