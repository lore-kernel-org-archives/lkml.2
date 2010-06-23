Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0FWDbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:31:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44116 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0FWDbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:31:01 -0400
Date: Wed, 23 Jun 2010 04:30:47 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Don Zickus <dzickus@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v3] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100623033047.GA32644@srcf.ucam.org>
References: <4C1A7D61.8010900@redhat.com> <20100621122145.76ebd7ac.akpm@linux-foundation.org> <20100621194559.GI3217@redhat.com> <20100621130008.d3dc01a8.akpm@linux-foundation.org> <20100622153457.GA5381@redhat.com> <20100622164835.4ddb9432@lxorguk.ukuu.org.uk> <20100622163817.GE20668@srcf.ucam.org> <20100622175741.6541ff2a@lxorguk.ukuu.org.uk> <20100622170410.GA22182@srcf.ucam.org> <20100623030637.GA30139@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623030637.GA30139@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 12:06:38PM +0900, Paul Mundt wrote:

> What exactly is the use case supposed to be? If drivers are supposed to
> call in to it for specific devices then they already have all of the
> information they need for constructing a device blacklist and providing
> more detailed information. If it's a configuration issue then we have
> device quirks, which could also be extended to other busses as needed. In
> either case, the context ought to be fairly explicit. I would much rather
> see a message from the bus code stating that a specific device has been
> disabled and skip the probe path entirely rather than trying to bolt on a
> system-wide unsupported hardware state.

Hardware may work, it may just not work well enough that a software 
vendor (eg, Red Hat) wants to deal with problem reports (eg, oopses 
caused by a network card DMAing to the wrong place) from systems with 
specific bits of hardware (eg, network cards that enjoy DMAing to the 
wrong place occasionally). It may not even be down to technical issues - 
the vendor may just have chosen to refuse to support systems with old 
CPU families. It'd be straightforward to make the kernel simply refuse 
to boot on them, but it seems more elegant to let it boot and alert the 
user to the situation.

I don't think it's a flag that would ever be used in mainline, and 
Alan's suggestion to just keep a range of taint flags as vendor-specific 
would avoid the risk of collisions in future. But there's a minor 
incentive to maintain standardisation over these things in order to 
encourage commonality of report code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
