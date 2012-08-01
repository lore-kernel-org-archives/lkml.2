Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2HAQSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:18:49 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:5707 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2HAQSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:18:48 -0400
X-IronPort-AV: E=Sophos;i="4.77,695,1336348800"; 
   d="scan'208";a="13807950"
Date: Wed, 1 Aug 2012 17:18:29 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 20/24] xen: update xen_add_to_physmap interface
In-Reply-To: <20120801145215.GP7227@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208011716040.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-20-git-send-email-stefano.stabellini@eu.citrix.com> <20120801145215.GP7227@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 26, 2012 at 04:34:02PM +0100, Stefano Stabellini wrote:
> > Update struct xen_add_to_physmap to be in sync with Xen's version of the
> > structure.
> > The size field was introduced by:
> > 
> > changeset:   24164:707d27fe03e7
> > user:        Jean Guyader <jean.guyader@eu.citrix.com>
> > date:        Fri Nov 18 13:42:08 2011 +0000
> > summary:     mm: New XENMEM space, XENMAPSPACE_gmfn_range
> > 
> > According to the comment:
> > 
> > "This new field .size is located in the 16 bits padding between .domid
> > and .space in struct xen_add_to_physmap to stay compatible with older
> > versions."
> > 
> > This is not true on ARM where there is not padding, but it is valid on
> > X86, so introducing size is safe on X86 and it is going to fix the
> > interace for ARM.
> 
> Has this been checked actually for backwards compatibility? It sounds
> like it should work just fine with Xen 4.0 right?
> 
> I believe this also helps Mukesh's patches, so CC-ing him here for
> his Ack.
> 
> I can put this in right now in tree if we are 100% sure its compatiblie with 4.0.

Yes, it is: 4 bytes integers are 4-byte aligned on 32 bit and 64 bit
on x86.
