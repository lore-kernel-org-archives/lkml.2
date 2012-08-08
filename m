Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab2HHQdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:33:36 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:54383 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2HHQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:33:34 -0400
X-IronPort-AV: E=Sophos;i="4.77,733,1336348800"; 
   d="scan'208";a="13914251"
Date: Wed, 8 Aug 2012 17:33:09 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH v2 03/23] xen/arm: page.h definitions
In-Reply-To: <20120807181322.GG15053@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208081732590.21096@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com> <1344263246-28036-3-git-send-email-stefano.stabellini@eu.citrix.com> <20120807181322.GG15053@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, Aug 06, 2012 at 03:27:06PM +0100, Stefano Stabellini wrote:
> > ARM Xen guests always use paging in hardware, like PV on HVM guests in
> > the X86 world.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Ack.. with one nitpick
> 
> > +/* XXX: this shouldn't be here */
> 
> .. but its here b/c the frontend drivers are using it (its rolled in
> headers)- even though we won't hit the code path. So for right now
> just punt with this.

Yep, I'll do that.


> > +static inline pte_t *lookup_address(unsigned long address, unsigned int *level)
> > +{
> > +	BUG();
> > +	return NULL;
> > +}
> > +
> > +static inline int m2p_add_override(unsigned long mfn, struct page *page,
> > +		struct gnttab_map_grant_ref *kmap_op)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline int m2p_remove_override(struct page *page, bool clear_pte)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> > +{
> > +	BUG();
> > +	return false;
> > +}
> > +#endif /* _ASM_ARM_XEN_PAGE_H */
> > -- 
> > 1.7.2.5
> 
