Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab2C2Ny5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:54:57 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:39682 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758910Ab2C2Nyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:54:52 -0400
X-IronPort-AV: E=Sophos;i="4.75,337,1330905600"; 
   d="scan'208";a="11643562"
Date: Thu, 29 Mar 2012 14:56:10 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen-blkfront: set pages are FOREIGN_FRAME
 when sharing them
In-Reply-To: <20120327175843.GA4299@andromeda.dapyr.net>
Message-ID: <alpine.DEB.2.00.1203291449360.15151@kaball-desktop>
References: <1332856198-29770-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120327175843.GA4299@andromeda.dapyr.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 27, 2012 at 02:49:58PM +0100, Stefano Stabellini wrote:
> > Set pages as FOREIGN_FRAME whenever blkfront shares them with another
> > domain. Then when blkfront un-share them, also removes the
> > FOREIGN_FRAME_BIT from the p2m.
> > 
> > We do it so that when the source and the destination domain are the same
> > (blkfront connected to blkback in the same domain) we can more easily
> > recognize which ones are the source pfns and which ones are the
> > destination pfns (both are going to be pointing to the same mfns).
> > 
> > Without this patch enstablishing a connection between blkfront and QEMU
> > qdisk in the same domain causes QEMU to hang and never return.
> > Considering that it fixes a serious bug, it should be backported to
> > previous releases.
> 
> 
> ERROR: "set_phys_to_machine" [drivers/block/xen-blkfront.ko] undefined!

I cannot reproduce this error: set_phys_to_machine is defined in
arch/x86/include/asm/xen/page.h, that is included by include/xen/page.h,
that is included by blkfront).
What CS did you apply this patch to? What is your config?
