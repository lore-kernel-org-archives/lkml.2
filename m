Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1HCFGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 01:06:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39083 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1HCFGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 01:06:19 -0400
Date: Wed, 3 Aug 2011 01:06:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>, Annie Li <annie.li@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xen-blkback: add remove_requested to xen_blkif and
 some declares
Message-ID: <20110803050601.GE18496@dumpdata.com>
References: <4E38ADA0.4030304@oracle.com>
 <4E38AE71.5040008@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E38AE71.5040008@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4E38D744.0028,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 10:12:01AM +0800, Joe Jin wrote:
> Add remove_requested to xen_blkif and some declares.
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> Cc: Daniel Stodden <daniel.stodden@citrix.com>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Annie Li <annie.li@oracle.com>
> Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
> ---
>  drivers/block/xen-blkback/common.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index 9e40b28..453fecf 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -49,6 +49,7 @@
>  	pr_debug(DRV_PFX "(%s:%d) " fmt ".\n",	\
>  		 __func__, __LINE__, ##args)
>  
> +#define WPRINTK(fmt, args...) printk(KERN_WARNING "xen-blkback: " fmt, ##args)
>  
>  /* Not a real protocol.  Used to generate ring structs which contain
>   * the elements common to all protocols only.  This way we get a
> @@ -145,6 +146,7 @@ struct xen_blkif {
>  	/* Back pointer to the backend_info. */
>  	struct backend_info	*be;
>  	/* Private fields. */
> +	int			remove_requested;

bool?
>  	spinlock_t		blk_ring_lock;
>  	atomic_t		refcnt;
>  
> @@ -198,6 +200,9 @@ int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
>  
>  struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be);
>  
> +void xen_vbd_sync(struct xen_vbd *vbd);
> +void xen_blkback_close(struct xen_blkif *blkif);
> +
>  static inline void blkif_get_x86_32_req(struct blkif_request *dst,
>  					struct blkif_x86_32_request *src)
>  {
> 
