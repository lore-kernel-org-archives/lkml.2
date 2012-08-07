Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2HGSXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:23:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34467 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2HGSXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:23:06 -0400
Date: Tue, 7 Aug 2012 14:13:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 03/23] xen/arm: page.h definitions
Message-ID: <20120807181322.GG15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-3-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:06PM +0100, Stefano Stabellini wrote:
> ARM Xen guests always use paging in hardware, like PV on HVM guests in
> the X86 world.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Ack.. with one nitpick

> +/* XXX: this shouldn't be here */

.. but its here b/c the frontend drivers are using it (its rolled in
headers)- even though we won't hit the code path. So for right now
just punt with this.

> +static inline pte_t *lookup_address(unsigned long address, unsigned int *level)
> +{
> +	BUG();
> +	return NULL;
> +}
> +
> +static inline int m2p_add_override(unsigned long mfn, struct page *page,
> +		struct gnttab_map_grant_ref *kmap_op)
> +{
> +	return 0;
> +}
> +
> +static inline int m2p_remove_override(struct page *page, bool clear_pte)
> +{
> +	return 0;
> +}
> +
> +static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> +{
> +	BUG();
> +	return false;
> +}
> +#endif /* _ASM_ARM_XEN_PAGE_H */
> -- 
> 1.7.2.5
