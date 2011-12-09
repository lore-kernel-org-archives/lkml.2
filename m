Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1LIRjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:39:01 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:10930 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1LIRjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:39:00 -0500
X-IronPort-AV: E=Sophos;i="4.71,327,1320624000"; 
   d="scan'208";a="9391073"
Subject: Re: [PATCH V3 1/2] xen/granttable: Support sub-page grants
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "annie.li@oracle.com" <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Fri, 9 Dec 2011 17:38:59 +0000
In-Reply-To: <1323430372-5503-1-git-send-email-annie.li@oracle.com>
References: <1323430321-5465-1-git-send-email-annie.li@oracle.com>
	 <1323430372-5503-1-git-send-email-annie.li@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323452339.20077.92.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 11:32 +0000, annie.li@oracle.com wrote:
> -- They can't be used to map the page (so can only be used in a GNTTABOP_copy
>        hypercall).
>     -- It's possible to grant access with a finer granularity than whole pages.
>     -- Xen guarantees that they can be revoked quickly (a normal map grant can
>        only be revoked with the cooperation of the domain which has been granted
>        access).
> 
> Signed-off-by: Annie Li <annie.li@oracle.com>
> ---
>  drivers/xen/grant-table.c |   71 +++++++++++++++++++++++++++++++++++++++++++++
>  include/xen/grant_table.h |   13 ++++++++
>  2 files changed, 84 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index bd325fd..0ac16fa 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -120,6 +120,16 @@ struct gnttab_ops {
>  	 * by bit operations.
>  	 */
>  	int (*query_foreign_access)(grant_ref_t);
> +	/*
> +	 * Grant a domain to access a range of bytes within the page referred by
> +	 * an available grant entry. First parameter is grant entry reference
> +	 * number, second one is id of grantee domain, third one is frame
> +	 * address of subpage grant, forth one is grant type and flag
> +	 * information, fifth one is offset of the range of bytes, and last one
> +	 * is length of bytes to be accessed.
> +	 */
> +	void (*update_subpage_entry)(grant_ref_t, domid_t, unsigned long, int,
> +				     unsigned, unsigned);

Please can you name the arguments here and then refer to them by name in
the comments instead of all this "First parameter", "second one" stuff.

Similarly for the existing comments sorry I didn't notice this in
previous review.

Ian.


