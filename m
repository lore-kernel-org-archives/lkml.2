Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2DCQXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:23:47 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53516 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab2DCQXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:23:46 -0400
X-IronPort-AV: E=Sophos;i="4.75,364,1330905600"; 
   d="scan'208";a="11751575"
Date: Tue, 3 Apr 2012 17:25:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/gntdev: do not set VM_PFNMAP
In-Reply-To: <20120403131947.GC12464@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1204031724340.15151@kaball-desktop>
References: <1333452302-5749-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120403131947.GC12464@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 03, 2012 at 12:25:02PM +0100, Stefano Stabellini wrote:
> > Since when we are using the m2p_override it is not true anymore that the
>         ^^^^ - get rid of that.
> > mmap'ed area doesn't have corresponsing struct pages.
> 
> That reads to me as !!do struct page. Which comes out as:
> 
> "m2p_override_* API the mmap-ed are have corresponding struct pages' ?

Yes, indeed: m2p_override_* provides the corresponding struct pages


> > Removing the VM_PFNMAP flag makes get_user_pages work on the mmap'ed user vma.
> > An example test case would be using a Xen userspace block backend
> > (QDISK) on a file on NFS using O_DIRECT.
> > 
> > The patch should be backported back to 2.6.38.
> 
> Add CC: stable@kernel.org then.

I'll resend CCing stable


> But does this patch depend on other
> patches?

only on the m2p_override, that is in Linux since 2.6.38
