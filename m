Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2GXQBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:01:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58394 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab2GXQBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:01:10 -0400
Date: Tue, 24 Jul 2012 18:01:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, netdev@vger.kernel.org,
        ben@decadent.org.uk
Subject: Re: [PATCH 09/17] Tools: hv: Represent the ipv6 mask using CIDR
 notation
Message-ID: <20120724160108.GA13749@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
	virtualization@lists.osdl.org, olaf@aepfle.de, apw@canonical.com,
	netdev@vger.kernel.org, ben@decadent.org.uk
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-9-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343145701-3691-9-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 09:01:33AM -0700, K. Y. Srinivasan wrote:
> Transform ipv6 subnet information to CIDR notation.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  tools/hv/hv_kvp_daemon.c |   45 +++++++++++++++++++++++++++++++++++----------
>  1 files changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 2c24ebf..007e698 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -491,6 +491,15 @@ done:
>  	return;
>  }
>  
> +static unsigned int hweight32(unsigned int *w)
> +{
> +	unsigned int res = *w - ((*w >> 1) & 0x55555555);
> +	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
> +	res = (res + (res >> 4)) & 0x0F0F0F0F;
> +	res = res + (res >> 8);
> +	return (res + (res >> 16)) & 0x000000FF;
> +}

What's wrong with the hweight32 version we have already in
<include/asm-generic/bitops/const_hweight.h> which you can include by
simply by including <asm-generic/bitops.h>?

-- 
Regards/Gruss,
Boris.
