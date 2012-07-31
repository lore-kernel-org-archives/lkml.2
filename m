Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab2GaXqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:46:24 -0400
Received: from ozlabs.org ([203.10.76.45]:45784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab2GaXqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:46:21 -0400
From: Michael Neuling <mikey@neuling.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, anton@samba.org
Subject: Re: [PATCH] powerpc/crypto: fix pseries_defconfig break
In-reply-to: <1343777691-25601-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1343777691-25601-1-git-send-email-sjenning@linux.vnet.ibm.com>
Comments: In-reply-to Seth Jennings <sjenning@linux.vnet.ibm.com>
   message dated "Tue, 31 Jul 2012 18:34:51 -0500."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Wed, 01 Aug 2012 09:46:19 +1000
Message-ID: <28116.1343778379@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:

> As part of the Kconfig rework for drivers/crypto/nx, the meaning of
> CONFIG_CRYPTO_DEV_NX was changed.  At the same time this commit was
> heading upstream
> 
> fd297b3a7302ab866306f53c1fd1e97b083fe83e
> powerpc: Enable pseries hardware RNG and crypto module
> 
> still used the old meaning, set CONFIG_CRYPTO_DEV_NX=m when it
> is now a bool in the Kconfig.  This patch repairs the break.
> 
> Reported-by: Michael Neuling <mikey@neuling.org>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
> This patch is based on Linus master which already contains
> the commit above.  Please apply this patch before my patchset
> (powerpc/crypto: IBM Power7+ in-Nest compression support) to
> avoid the pseries_defconfig break.
> 
>  arch/powerpc/configs/pseries_defconfig |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

ppc64_defconfig needs fixing too.

grep CONFIG_CRYPTO_DEV_NX=m arch/powerpc/configs/*
arch/powerpc/configs/ppc64_defconfig:CONFIG_CRYPTO_DEV_NX=m
arch/powerpc/configs/pseries_defconfig:CONFIG_CRYPTO_DEV_NX=m

Mikey

> 
> diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
> index 1f65b3c..9f4a936 100644
> --- a/arch/powerpc/configs/pseries_defconfig
> +++ b/arch/powerpc/configs/pseries_defconfig
> @@ -369,7 +369,8 @@ CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_LZO=m
>  # CONFIG_CRYPTO_ANSI_CPRNG is not set
>  CONFIG_CRYPTO_HW=y
> -CONFIG_CRYPTO_DEV_NX=m
> +CONFIG_CRYPTO_DEV_NX=y
> +CONFIG_CRYPTO_DEV_NX_ENCRYPT=m
>  CONFIG_VIRTUALIZATION=y
>  CONFIG_KVM_BOOK3S_64=m
>  CONFIG_KVM_BOOK3S_64_HV=y
> -- 
> 1.7.9.5
> 
