Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab2JXJhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:37:51 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:55171 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab2JXJhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:37:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15352638"
Message-ID: <1351071465.2237.128.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 01/10] xen/pvh: Support ParaVirtualized Hardware
 extensions.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>
Date: Wed, 24 Oct 2012 10:37:45 +0100
In-Reply-To: <1351015931-16991-2-git-send-email-konrad.wilk@oracle.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
	 <1351015931-16991-2-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 19:12 +0100, Konrad Rzeszutek Wilk wrote:
> diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> index 1844d31..83050d3 100644
> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -274,6 +274,16 @@ struct physdev_dbgp_op {
>      } u;
>  };
>  
> +#define PHYSDEVOP_map_iomem        30
> +struct physdev_map_iomem {
> +    /* IN */
> +    uint64_t first_gfn;
> +    uint64_t first_mfn;
> +    uint32_t nr_mfns;
> +    uint32_t add_mapping; /* 1 == add mapping;  0 == unmap */

I think we would usually have map and unmap as separate ops.

> +
> +};
> +
>  /*
>   * Notify that some PIRQ-bound event channels have been unmasked.
>   * ** This command is obsolete since interface version 0x00030202 and is **


