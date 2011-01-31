Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1AaO0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:26:18 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:26376 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1AaO0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:26:17 -0500
X-IronPort-AV: E=Sophos;i="4.60,404,1291593600"; 
   d="scan'208";a="4061469"
Date: Mon, 31 Jan 2011 14:27:47 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Daniel Kiper <dkiper@net-space.pl>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>
Subject: Re: [Xen-devel] [PATCH] xen: convert p2m to a 3 level tree - partial
 revert
In-Reply-To: <20110131112108.GA30595@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1101311427150.7277@kaball-desktop>
References: <20110127144843.GA23746@router-fw-old.local.net-space.pl> <20110127152508.GC3282@dumpdata.com> <20110131112108.GA30595@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Daniel Kiper wrote:
> Hi,
> 
> On Thu, Jan 27, 2011 at 10:25:08AM -0500, Konrad Rzeszutek Wilk wrote:
> > On Thu, Jan 27, 2011 at 03:48:43PM +0100, Daniel Kiper wrote:
> > > Hi,
> > >
> > > Durning work on Xen memory hotplug I discoverd that
> > > 2.6.38-rc2 does not boot on domU. After some investigation
> > > it appeared that 58e05027b530ff081ecea68e38de8d59db8f87e0
> > > commit changed CONFIG_XEN_MAX_DOMAIN_MEMORY constant value
> > > to 128. This change does not allow to boot kernel on domU
> > > with small memory size (I could confirm that it is even
> > > not possible to boot kernel on domU with 2 GiB). Guest
> >
> > Strange.. I've been booting with 1G, 2G, 3G, 4G guests.
> >
> > Could you give more details? Is this a 32-bit guest? 64-bit?
> > What does your xm file look like?
> >
> > > crash silently without any warning. Durning further
> > > research I found out that there is another commit published
> > > recently (8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b) which attempts
> > > to fix this issue, however, it does not work on my platform.
> > > I decided to reenable CONFIG_XEN_MAX_DOMAIN_MEMORY option in
> > > kernel config and enable users to choose resonable values for
> > > their machines until better fix will be published. I think this
> > > solution is good because allow users to boot domU with newest
> > > kernel and allow developers to continue their work without
> > > time presure which could lead to new bugs.
> >
> > I think you are hitting a completly different bug. This
> > patch of yours changes the size of the structure - so it could
> > be that you are hitting a page-table overwrite. This is something
> > that Stefano has been looking at - you might want to take a look at
> > "x86: When destroying mappings between _brk_end and _end, do not go over _end"
> > (it is present in his git tree).
> 
> It appears that this patch fixed issue described above. In this
> situation I think it should be applied ASAP to RC and stable kernels.
> 

I am reworking the patch as we speak, I should have an upstreamable
version ready very soon.
