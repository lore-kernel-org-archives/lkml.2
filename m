Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2GQPWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:22:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:56202 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab2GQPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:22:20 -0400
X-IronPort-AV: E=Sophos;i="4.77,603,1336363200"; 
   d="scan'208";a="202430051"
Message-ID: <50058319.2030502@citrix.com>
Date: Tue, 17 Jul 2012 16:22:01 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86: add desc_equal() to compare GDT descriptors
References: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com> <1341830348-15529-4-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1341830348-15529-4-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/12 11:39, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

ping?  Can we get an x86 an x86 maintainer for this patch, please?

David

> ---
>  arch/x86/include/asm/desc.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
> index 8bf1c06..d26f059 100644
> --- a/arch/x86/include/asm/desc.h
> +++ b/arch/x86/include/asm/desc.h
> @@ -85,6 +85,12 @@ static inline int desc_empty(const void *ptr)
>  	return !(desc[0] | desc[1]);
>  }
>  
> +static inline bool desc_equal(const struct desc_struct *d1,
> +			      const struct desc_struct *d2)
> +{
> +	return d1->a == d2->a && d1->b == d2->b;
> +}
> +
>  #ifdef CONFIG_PARAVIRT
>  #include <asm/paravirt.h>
>  #else
