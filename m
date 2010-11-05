Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0KENI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:08:58 -0400
Received: from ozlabs.org ([203.10.76.45]:46212 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab0KENIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:08:55 -0400
From: Jeremy Kerr <jk@ozlabs.org>
To: cbe-oss-dev@lists.ozlabs.org
Subject: Re: [Cbe-oss-dev] [PATCH 03/49] arch/powerpc: Use vzalloc
Date: Fri, 5 Nov 2010 09:08:49 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, Jiri Kosina <trivial@kernel.org>,
        kvm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Avi Kivity <avi@redhat.com>
References: <alpine.DEB.2.00.1011031108260.11625@router.home> <5da00d7f95b5c7a96fbfa8420f5e3a8ef33e01e6.1288925424.git.joe@perches.com>
In-Reply-To: <5da00d7f95b5c7a96fbfa8420f5e3a8ef33e01e6.1288925424.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011050908.50190.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> diff --git a/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
> b/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c index a101abf..3b894f5
> 100644
> --- a/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
> +++ b/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
> @@ -36,10 +36,9 @@ static int spu_alloc_lscsa_std(struct spu_state *csa)
>  	struct spu_lscsa *lscsa;
>  	unsigned char *p;
> 
> -	lscsa = vmalloc(sizeof(struct spu_lscsa));
> +	lscsa = vzalloc(sizeof(struct spu_lscsa));
>  	if (!lscsa)
>  		return -ENOMEM;
> -	memset(lscsa, 0, sizeof(struct spu_lscsa));
>  	csa->lscsa = lscsa;
> 
>  	/* Set LS pages reserved to allow for user-space mapping. */

For the spufs bit:

Acked-By: Jeremy Kerr <jk@ozlabs.org>

Cheers,


Jeremy
