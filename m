Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2INNZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:25:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27543 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2INNZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:25:01 -0400
Date: Fri, 14 Sep 2012 09:13:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: arnd@arndb.de, linux@arm.linux.org.uk, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        tim@xen.org, Ian.Campbell@citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 23/24] xen: update xen_add_to_physmap interface
Message-ID: <20120914131357.GO25249@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
 <1347621207-11294-23-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347621207-11294-23-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:13:25PM +0100, Stefano Stabellini wrote:
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
> Note: this patch should be already in Konrad's tree, it is here just for
> convenience.
> 
> Changes in v2:
> 
> - remove erroneous comment in the commit message.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

.. and I already have this queued for 3.7.
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
