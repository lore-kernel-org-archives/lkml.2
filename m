Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab2HAPBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:01:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24592 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2HAPBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:01:32 -0400
Date: Wed, 1 Aug 2012 10:52:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH 20/24] xen: update xen_add_to_physmap interface
Message-ID: <20120801145215.GP7227@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-20-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343316846-25860-20-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:34:02PM +0100, Stefano Stabellini wrote:
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
> This is not true on ARM where there is not padding, but it is valid on
> X86, so introducing size is safe on X86 and it is going to fix the
> interace for ARM.

Has this been checked actually for backwards compatibility? It sounds
like it should work just fine with Xen 4.0 right?

I believe this also helps Mukesh's patches, so CC-ing him here for
his Ack.

I can put this in right now in tree if we are 100% sure its compatiblie with 4.0.

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  include/xen/interface/memory.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index abbbff0..d8e33a9 100644
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
