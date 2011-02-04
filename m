Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1BDUKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:10:22 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34359 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1BDUKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:10:20 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19IKLdex/khTA2cM/gZU/9Z
Date: Fri, 4 Feb 2011 12:09:47 -0800
From: Tony Lindgren <tony@atomide.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/20] mach-omap2: mux: world-writable debugfs files
Message-ID: <20110204200947.GB3322@atomide.com>
References: <cover.1296818921.git.segoon@openwall.com>
 <1aa2fe44c18b9f24eb52a1be98d017f1f568e6bb.1296818921.git.segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aa2fe44c18b9f24eb52a1be98d017f1f568e6bb.1296818921.git.segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vasiliy Kulikov <segoon@openwall.com> [110204 04:21]:
> Do not create mux debugfs files as world-writable.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Cannot compile the driver, so it is not tested at all.

Thanks, will queue this as a fix for the -rc cycle.

Tony
 
>  arch/arm/mach-omap2/mux.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
> index 98148b6..6c84659 100644
> --- a/arch/arm/mach-omap2/mux.c
> +++ b/arch/arm/mach-omap2/mux.c
> @@ -605,7 +605,7 @@ static void __init omap_mux_dbg_create_entry(
>  	list_for_each_entry(e, &partition->muxmodes, node) {
>  		struct omap_mux *m = &e->mux;
>  
> -		(void)debugfs_create_file(m->muxnames[0], S_IWUGO, mux_dbg_dir,
> +		(void)debugfs_create_file(m->muxnames[0], S_IWUSR, mux_dbg_dir,
>  					  m, &omap_mux_dbg_signal_fops);
>  	}
>  }
> -- 
> 1.7.0.4
> 
