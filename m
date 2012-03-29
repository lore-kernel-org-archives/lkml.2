Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab2C2OPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:15:10 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:27608 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758633Ab2C2OPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:15:06 -0400
X-IronPort-AV: E=Sophos;i="4.75,337,1330905600"; 
   d="scan'208";a="11645060"
Message-ID: <1333030435.2485.128.camel@leeds.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen-blkfront: set pages are FOREIGN_FRAME
 when sharing them
From: Wei Liu <wei.liu2@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <wei.liu2@citrix.com>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Thu, 29 Mar 2012 15:13:55 +0100
In-Reply-To: <alpine.DEB.2.00.1203291449360.15151@kaball-desktop>
References: <1332856198-29770-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20120327175843.GA4299@andromeda.dapyr.net>
	 <alpine.DEB.2.00.1203291449360.15151@kaball-desktop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 14:56 +0100, Stefano Stabellini wrote:
> On Tue, 27 Mar 2012, Konrad Rzeszutek Wilk wrote:
> > On Tue, Mar 27, 2012 at 02:49:58PM +0100, Stefano Stabellini wrote:
> > > Set pages as FOREIGN_FRAME whenever blkfront shares them with another
> > > domain. Then when blkfront un-share them, also removes the
> > > FOREIGN_FRAME_BIT from the p2m.
> > > 
> > > We do it so that when the source and the destination domain are the same
> > > (blkfront connected to blkback in the same domain) we can more easily
> > > recognize which ones are the source pfns and which ones are the
> > > destination pfns (both are going to be pointing to the same mfns).
> > > 
> > > Without this patch enstablishing a connection between blkfront and QEMU
> > > qdisk in the same domain causes QEMU to hang and never return.
> > > Considering that it fixes a serious bug, it should be backported to
> > > previous releases.
> > 
> > 
> > ERROR: "set_phys_to_machine" [drivers/block/xen-blkfront.ko] undefined!
> 
> I cannot reproduce this error: set_phys_to_machine is defined in
> arch/x86/include/asm/xen/page.h, that is included by include/xen/page.h,
> that is included by blkfront).
> What CS did you apply this patch to? What is your config?
> 

In arch/x86/xen/p2m.c, set_phys_to_machine is not exported. You need
another patch to do that.

It might be that you were using a monolithic kernel so that you didn't
see this error.


Wei.

> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel


