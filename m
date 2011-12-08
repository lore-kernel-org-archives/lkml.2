Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab1LHARQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:17:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1LHARP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:17:15 -0500
Date: Wed, 7 Dec 2011 16:16:45 -0800
From: Chris Wright <chrisw@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        David Gibson <dwg@au1.ibm.com>, joerg.roedel@amd.com,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com
Subject: Re: RFC: Device isolation infrastructure
Message-ID: <20111208001645.GJ2395@x200.localdomain>
References: <20111207035816.GC7631@truffala.fritz.box>
 <1323240402.2182.241.camel@bling.home>
 <20111207142201.GA5696@truffala.fritz.box>
 <1323287120.15059.63.camel@bling.home>
 <1323301293.12793.16.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323301293.12793.16.camel@pasglop>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt (benh@kernel.crashing.org) wrote:
> After much thinking, I believe that the driver ownership model is the
> right one. However, we could still use the work David did here. IE. I
> _do_ think that exposing groups as the individual unit of ownership to
> user space is the right thing to do.

OK, I think I agree at least w/ the ownership model...

> That means that instead of that current detached flag alone, what we
> could do instead is have an in-kernel mechanism to request isolation
> which works by having the isolation group kernel code perform:
> 
>  - Rename the detached flag to "exclusive". This flag prevents automatic
> & user driven attachment of a driver by the generic code. Set that flag
> on all devices in the group (need a hook for hotplug).
> 
>  - Detach existing drivers.
> 
>  - Once everything is detached, attach the requested client driver (vfio
> being the one we initially provide, maybe uio could use that framework
> as well). This can be done using an explicit in-kernel attach API that
> can be used even when the exclusive flag is set.

Since users will want to drive devices, not groups, how would you
enumerate and expose devices here if the user visible construct exposed
is groups?

thanks,
-chris
