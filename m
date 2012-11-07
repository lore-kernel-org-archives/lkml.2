Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2KGHXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:23:47 -0500
Received: from smtp.citrix.com ([66.165.176.89]:60834 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2KGHXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:23:46 -0500
X-IronPort-AV: E=Sophos;i="4.80,727,1344211200"; 
   d="scan'208";a="43746809"
Message-ID: <1352272882.12977.19.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/arm: Fix compile errors when
 drivers are compiled as modules.
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Wed, 7 Nov 2012 08:21:22 +0100
In-Reply-To: <1352239982-17389-3-git-send-email-konrad.wilk@oracle.com>
References: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>
	 <1352239982-17389-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing Russell since I believe this is the fix for the "BUG: ARM build
failures due to Xen" failure he reported yesterday,

On Tue, 2012-11-06 at 22:13 +0000, Konrad Rzeszutek Wilk wrote:
> We end up with:
> 
> ERROR: "HYPERVISOR_event_channel_op" [drivers/xen/xen-gntdev.ko] undefined!
> ERROR: "privcmd_call" [drivers/xen/xen-privcmd.ko] undefined!
> ERROR: "HYPERVISOR_grant_table_op" [drivers/net/xen-netback/xen-netback.ko] undefined!
> 
> and this patch exports said function (which is implemented in hypercall.S).
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

> ---
>  arch/arm/xen/enlighten.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 59bcb96..96d969d 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -166,3 +166,8 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
>  	*pages = NULL;
>  }
>  EXPORT_SYMBOL_GPL(free_xenballooned_pages);
> +
> +/* In the hypervisor.S file. */
> +EXPORT_SYMBOL_GPL(HYPERVISOR_event_channel_op);
> +EXPORT_SYMBOL_GPL(HYPERVISOR_grant_table_op);
> +EXPORT_SYMBOL_GPL(privcmd_call);


