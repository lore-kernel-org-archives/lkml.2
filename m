Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab1EYXfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:35:15 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:34526 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab1EYXfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:35:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMBACWR3U2tJV2Y/2dsb2JhbACXb45EeKhBnWCGHASGW44UimU
X-IronPort-AV: E=Sophos;i="4.65,270,1304294400"; 
   d="scan'208";a="364363062"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
Date: Wed, 25 May 2011 18:35:10 -0500
Message-ID: <13EBEADFAA5B5041B7FC8A3311E7DD1C044D22F3@XMB-RCD-104.cisco.com>
In-Reply-To: <BANLkTi=Jc11hO3KXWFUaX1pia-MGa2SV+A@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
Thread-Index: AcwbEf7nP6PwsfFTT/Osl4Qa+yhc7AAHsHqQ
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com> <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com> <20110525080409.GA16582@infradead.org> <BANLkTi=Jc11hO3KXWFUaX1pia-MGa2SV+A@mail.gmail.com>
From: "Abhijeet Joglekar (abjoglek)" <abjoglek@cisco.com>
To: "Roland Dreier" <roland@kernel.org>,
        "Christoph Hellwig" <hch@infradead.org>
Cc: "David Rientjes" <rientjes@google.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        "Pekka Enberg" <penberg@kernel.org>,
        "Christoph Lameter" <cl@linux.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 May 2011 23:35:11.0368 (UTC) FILETIME=[63CF4880:01CC1B34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: roland@purestorage.com [mailto:roland@purestorage.com] On Behalf
> Of Roland Dreier
> Sent: Wednesday, May 25, 2011 12:29 PM
> To: Christoph Hellwig
> Cc: David Rientjes; James E.J. Bottomley; Pekka Enberg; Christoph
> Lameter; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> Abhijeet Joglekar (abjoglek); Joe Eykholt
> Subject: Re: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
> 
> On Wed, May 25, 2011 at 1:04 AM, Christoph Hellwig <hch@infradead.org>
> wrote:
> >> The Cisco FNIC driver requires creating a SLAB_CACHE_DMA cache,
> which is
> >> not possible if CONFIG_ZONE_DMA is disasbled.  Avoid compiling it
> without
> >> DMA support.
> >
> > And you're sure it actually needs it and isn't some sort of typo?  It
> > might help to Cc the maintainer to figure that out.
> 
> Yes, almost certainly it is due to a misunderstanding of what
> SLAB_CACHE_DMA means.
> (fnic is a modern PCIe device that doesn't have 24-bit DMA restrictions
> ;)
> 
> So the correct fix would likely be to delete the SLAB_CACHE_DMA from
> the driver.
> 
> In any case cc'ing Cisco people as hch suggested...
> 
>  - R.

You are right, fnic hardware does not have any 24-bit DMA restrictions. When I coded it up, I misunderstood the flag as something that is required for allocating memory that hardware DMAs in/out of.

As Roland indicated, the correct fix would be to remove the SLAB_CACHE_DMA flag from the call to kmem_cache, and the GFP_DMA from the call to the mempool allocation routine.

I can create a patch (attributing the fix to David and Roland) and send out for review. Or if David wants, he can modify the patch he submitted to include this fix. David, please let me know how you want to proceed.

Thanks
-- abhijeet
