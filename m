Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2GDLt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:49:28 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:16936 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab2GDLtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:49:23 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336348800"; 
   d="scan'208";a="13364788"
Message-ID: <1341402545.31696.50.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH WIP 2/5] xen/arm: set xen_platform_pci_unplug to
 XEN_UNPLUG_ALL
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 4 Jul 2012 12:49:05 +0100
In-Reply-To: <alpine.DEB.2.02.1207041226150.31911@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
	 <1341400520-31770-2-git-send-email-stefano.stabellini@eu.citrix.com>
	 <4FF4281E.9040801@citrix.com>
	 <alpine.DEB.2.02.1207041226150.31911@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 12:27 +0100, Stefano Stabellini wrote:
> On Wed, 4 Jul 2012, David Vrabel wrote:
> > On 04/07/12 12:15, Stefano Stabellini wrote:
> > > Set xen_platform_pci_unplug to XEN_UNPLUG_ALL by default to make
> > > blkfront happy. The parameter doesn't make sense on ARM and should be
> > > removed.
> > 
> > Why is this parameter nonsensical on ARM?  ARM systems can have PCI devices.
> 
> Because we shouldn't assume the presence of a PCI bus on ARM. Moreover
> it would be nice to avoid the ugly unplug protocol entirely if we can.

Also "pci" here refers to the "platform_pci" device not to PCI devices
in general.

SO I think this option is indeed nonsensical at least until such a time
as we have HVM like ARM guests (i.e. ones with a DM emulating specific
platforms) which require a PCI device which serves as the "you are
running under Xen" hook intp to the non-PV aware OSes driver subsystem.
And it's not clear that when we have such guests that a platform pci
device will be the correct solution on ARM anyway.

Ian.


