Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab0EYQ7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:59:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:41826 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602Ab0EYQ7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:59:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,299,1272870000"; 
   d="scan'208";a="570386590"
Date: Tue, 25 May 2010 09:27:25 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
cc: "stable@kernel.org" <stable@kernel.org>, "greg@kroah.com" <greg@kroah.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "davem@davemloft.net" <davem@davemloft.net>, Brandon <brandon@ifup.org>
Subject: Re: [stable-2.6.32 PATCH] ixgbe: backport bug fix for tx panic
In-Reply-To: <AANLkTinHm8ukQ3KlcrMKWvQ-QrlmBcWeVD-i99Q9Z7JL@mail.gmail.com>
Message-ID: <alpine.WNT.2.00.1005250926320.2708@jbrandeb-desk1.amr.corp.intel.com>
References: <20100511004655.30590.74584.stgit@localhost.localdomain> <AANLkTinHm8ukQ3KlcrMKWvQ-QrlmBcWeVD-i99Q9Z7JL@mail.gmail.com>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 May 2010, Jeff Kirsher wrote:

> On Mon, May 10, 2010 at 17:46, Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:
> > From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >
> > backporting this commit:
> >
> > commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f
> > Author: Krishna Kumar <krkumar2@in.ibm.com>
> > Date:   Wed Feb 3 13:13:10 2010 +0000
> >
> >    ixgbe: Fix return of invalid txq
> >
> >    a developer had complained of getting lots of warnings:
> >
> >    "eth16 selects TX queue 98, but real number of TX queues is 64"
> >
> >    http://www.mail-archive.com/e1000-devel@lists.sourceforge.net/msg02200.html
> >
> >    As there was no follow up on that bug, I am submitting this
> >    patch assuming that the other return points will not return
> >    invalid txq's, and also that this fixes the bug (not tested).
> >
> >    Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> >    Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >    Acked-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> >    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> >    Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > CC: Brandon <brandon@ifup.org>
> > Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > ---
> >
> >  drivers/net/ixgbe/ixgbe_main.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> >
> 
> Greg - status?  Did you queue this patch for the stable release and I missed it?

Maybe we didn't say (and we should have) that this fixes a panic on 
machines with > 64 cores.  Please apply to -stable 32.

