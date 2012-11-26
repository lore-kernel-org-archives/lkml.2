Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2KZUa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:30:28 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:34536 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab2KZUa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:30:26 -0500
Date: Mon, 26 Nov 2012 13:30:19 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Peter.Huewe@infineon.com,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] TPM: Switch to __packed instead of
 __attribute__((packed))
Message-ID: <20121126203019.GA18296@obsidianresearch.com>
References: <20121121205645.GB15285@obsidianresearch.com>
 <201211212350.24836.PeterHuewe@gmx.de>
 <20121126202356.GC12737@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126202356.GC12737@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 02:23:56PM -0600, Kent Yoder wrote:
> On Wed, Nov 21, 2012 at 11:50:24PM +0100, Peter Huewe wrote:
> > Am Mittwoch, 21. November 2012, 21:56:45 schrieb Jason Gunthorpe:
> > > This seems to be preferred these days.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > 
> > Looks good to me
> > Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
> 
> Applied. I also rolled in an update to tpm_acpi.c to this commit:
> 
> diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
> index 56051d0..64420b3 100644
> +++ b/drivers/char/tpm/tpm_acpi.c
> @@ -33,13 +33,13 @@ struct acpi_tcpa {
>  	u16 platform_class;
>  	union {
>  		struct client_hdr {
> -			u32 log_max_len __attribute__ ((packed));
> -			u64 log_start_addr __attribute__ ((packed));
> +			u32 log_max_len __packed;
> +			u64 log_start_addr __packed;
>  		} client;
>  		struct server_hdr {
>  			u16 reserved;
> -			u64 log_max_len __attribute__ ((packed));
> -			u64 log_start_addr __attribute__ ((packed));
> +			u64 log_max_len __packed;
> +			u64 log_start_addr __packed;
>  		} server;
>  	};
>  };

Thanks, I looked at those as well, but I couldn't grok the
intent. What does __packed on a member even do??

Certainly client_hdr should be moved to the struct, maybe server_hdr
too?

Jason
