Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab0ESMUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:20:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:35365 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0ESMUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:20:51 -0400
X-IronPort-AV: E=Sophos;i="4.53,263,1272859200"; 
   d="scan'208";a="97690496"
Date: Wed, 19 May 2010 13:24:10 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 03/12] evtchn delivery on HVM
In-Reply-To: <4BF2CBA5.3020205@goop.org>
Message-ID: <alpine.DEB.2.00.1005191315160.11380@kaball-desktop>
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-3-git-send-email-stefano.stabellini@eu.citrix.com> <4BF2CBA5.3020205@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Jeremy Fitzhardinge wrote:
> On 05/18/2010 03:22 AM, Stefano Stabellini wrote:
> > From: Sheng Yang <sheng@linux.intel.com>
> >
> > Set the callback to receive evtchns from Xen, using the
> > callback vector delivery mechanism.
> >   
> 
> Could you expand on this a little?  Like, why is this desireable?  What
> functional difference does it make?  Is this patch useful in its own
> right, or is it just laying the groundwork for something else?
> 

In order to use PV frontends on HVM we need to receive notifications on
event channel deliveries somehow.
Using the callback vector is the preferred way, because it is available
independently from any (emulated) PCI device, all the vcpus can receive
these callbacks and theoretically there is no need to interact with the
emulated lapic (even though at the moment we are doing it anyway because
we are using the IPI vector).
The other way is to receive interrupts from the xen platform pci device,
but in that case interaction with the emulated lapic is unavoidable and
we are limited to receive interrupts on vcpu 0.


