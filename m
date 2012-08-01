Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2HAPDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:03:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17940 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2HAPDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:03:34 -0400
Date: Wed, 1 Aug 2012 10:54:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH 23/24] hvc_xen: allow dom0_write_console for HVM guests
Message-ID: <20120801145413.GR7227@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-23-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343316846-25860-23-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:34:05PM +0100, Stefano Stabellini wrote:
> On ARM all guests are HVM guests, including Dom0.
> Allow dom0_write_console to be called by an HVM domain.

Um, but xen_hvm_domain() != xen_pv_domain() so won't this return without
printing anything?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/tty/hvc/hvc_xen.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> index 3c04fb8..949edc2 100644
> --- a/drivers/tty/hvc/hvc_xen.c
> +++ b/drivers/tty/hvc/hvc_xen.c
> @@ -616,12 +616,9 @@ static void xenboot_write_console(struct console *console, const char *string,
>  	unsigned int linelen, off = 0;
>  	const char *pos;
>  
> -	if (!xen_pv_domain())
> -		return;
> -
>  	dom0_write_console(0, string, len);
>  
> -	if (xen_initial_domain())
> +	if (!xen_pv_domain())
>  		return;
>  
>  	domU_write_console(0, "(early) ", 8);
> -- 
> 1.7.2.5
