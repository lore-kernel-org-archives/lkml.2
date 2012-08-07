Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab2HGSnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:43:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21928 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab2HGSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:43:06 -0400
Date: Tue, 7 Aug 2012 14:33:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 21/23] xen: update xen_add_to_physmap interface
Message-ID: <20120807183306.GX15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-21-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-21-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:24PM +0100, Stefano Stabellini wrote:
> Update struct xen_add_to_physmap to be in sync with Xen's version of the
> structure.
> The size field was introduced by:
> 
> changeset:   24164:707d27fe03e7
> user:        Jean Guyader <jean.guyader@eu.citrix.com>
> date:        Fri Nov 18 13:42:08 2011 +0000
> summary:     mm: New XENMEM space, XENMAPSPACE_gmfn_range
> 
> According to the comment:
> 
> "This new field .size is located in the 16 bits padding between .domid
> and .space in struct xen_add_to_physmap to stay compatible with older
> versions."
> 
> Changes in v2:

Looks good. Let me take this as in my tree to prep it for Mukesh's patches.

> 
> - remove erroneous comment in the commit message.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  include/xen/interface/memory.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index b5c3098..b66d04c 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -163,6 +163,9 @@ struct xen_add_to_physmap {
>      /* Which domain to change the mapping for. */
>      domid_t domid;
>  
> +    /* Number of pages to go through for gmfn_range */
> +    uint16_t    size;
> +
>      /* Source mapping space. */
>  #define XENMAPSPACE_shared_info 0 /* shared info page */
>  #define XENMAPSPACE_grant_table 1 /* grant table page */
> -- 
> 1.7.2.5
