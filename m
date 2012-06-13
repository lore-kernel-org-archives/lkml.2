Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2FMSom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:44:42 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45017 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2FMSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:44:39 -0400
Message-ID: <1339613130.28242.12.camel@key-ThinkPad-W510>
Subject: Re: [PATCH 1/2] drivers: crypto: move nx build to driver/crypto
 Makefile
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Date: Wed, 13 Jun 2012 13:45:30 -0500
In-Reply-To: <1339611763-14603-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1339611763-14603-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061318-4242-0000-0000-000001F5374D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 13:22 -0500, Seth Jennings wrote:
> When the nx driver was pulled, the Makefile that actually
> builds it is arch/powerpc/Makefile. This is unnatural.
> 
> This patch moves the line that builds the nx driver from
> arch/powerpc/Makefile to drivers/crypto/Makefile where it
> belongs.

Acked-by: Kent Yoder <key@linux.vnet.ibm.com>

> Cc: Kent Yoder <key@linux.vnet.ibm.com>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  arch/powerpc/Makefile   |    1 -
>  drivers/crypto/Makefile |    3 ++-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
> index 950d1f7..159e94f 100644
> --- a/arch/powerpc/Makefile
> +++ b/arch/powerpc/Makefile
> @@ -149,7 +149,6 @@ core-$(CONFIG_KVM) 		+= arch/powerpc/kvm/
>  core-$(CONFIG_PERF_EVENTS)	+= arch/powerpc/perf/
> 
>  drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
> -drivers-$(CONFIG_CRYPTO_DEV_NX) += drivers/crypto/nx/
> 
>  # Default to zImage, override when needed
>  all: zImage
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 0139032..67b4fbf 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -14,4 +14,5 @@ obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) += omap-aes.o
>  obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) += picoxcell_crypto.o
>  obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
>  obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) += tegra-aes.o
> -obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
> \ No newline at end of file
> +obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
> +obj-$(CONFIG_CRYPTO_DEV_NX) += nx/


