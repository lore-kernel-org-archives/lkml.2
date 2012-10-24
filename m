Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab2JXJk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:40:28 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:36062 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2JXJkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:40:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15352714"
Message-ID: <1351071622.2237.130.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 03/10] xen/hypercall: Make xen_remove_from_physmap the
 same on 64/32 builds.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>
Date: Wed, 24 Oct 2012 10:40:22 +0100
In-Reply-To: <1351015931-16991-4-git-send-email-konrad.wilk@oracle.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
	 <1351015931-16991-4-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 19:12 +0100, Konrad Rzeszutek Wilk wrote:
> By making the structure exactly the same size and with the same
> offsets on 64 and 32-bit builds we are future-proofing ourselves.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  include/xen/interface/memory.h |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index 8beebdb..6b07b54 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -253,9 +253,14 @@ extern spinlock_t xen_reservation_lock;
>  struct xen_remove_from_physmap {
>      /* Which domain to change the mapping for. */
>      domid_t domid;
> -
> +   /* To be used in the future if need to. */
> +    uint8_t reserved[6];
>      /* GPFN of the current mapping of the page. */
>      xen_pfn_t gpfn;
> +#ifdef CONFIG_X86_32
> +    /* No need to do that on ARM as xen_pfn_t is always 8 bytes. */
> +    uint8_t __pad[4];
> +#endif

I'm not sure if this last one is necessary since this isn't a struct
which would get used in an array. I guess it doesn't hurt though.

>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
>  


