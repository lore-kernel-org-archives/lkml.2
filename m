Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab1FILcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:32:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37028 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab1FILcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:32:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TLulXrucD/J+rrqRupyljlXFyzVm47f7RRznsnYNAiyTLiqh42om+91TMCWHM2mPs0
         ilt9E5ivLeX6utO28eI2Ctk94Qm6PMIcCrHC5153xfgcD4r3xM4pHcEm2fS03X3oAqad
         Ch8pSRZ0mvN9/bU2BuzMxXhMhMz4x9Ek+bC1o=
MIME-Version: 1.0
In-Reply-To: <1307617752-23426-1-git-send-email-gxt@mprc.pku.edu.cn>
References: <1307617752-23426-1-git-send-email-gxt@mprc.pku.edu.cn>
Date: Thu, 9 Jun 2011 20:32:40 +0900
Message-ID: <BANLkTikNC8uh-X_0iJZH3tYd_kf46W1Rwg@mail.gmail.com>
Subject: Re: [PATCH] unicore32: fix build error for find bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: GuanXuetao <gxt@mprc.pku.edu.cn>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/9 GuanXuetao <gxt@mprc.pku.edu.cn>:
> From: Guan Xuetao <gxt@mprc.pku.edu.cn>
>
> Remove the __uc32_ prefix in find bitops functions.
> see commit <19de85ef574c3a2182e3ccad9581805052f14946>
>  bitops: add #ifndef for each of find bitops
>
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  arch/unicore32/include/asm/bitops.h |    6 ------
>  arch/unicore32/kernel/ksyms.c       |    4 ++--
>  arch/unicore32/lib/findbit.S        |   14 ++++++++------
>  3 files changed, 10 insertions(+), 14 deletions(-)
>
> diff --git a/arch/unicore32/include/asm/bitops.h b/arch/unicore32/include/asm/bitops.h
> index 1628a63..a9653f0 100644
> --- a/arch/unicore32/include/asm/bitops.h
> +++ b/arch/unicore32/include/asm/bitops.h
> @@ -13,12 +13,6 @@
>  #ifndef __UNICORE_BITOPS_H__
>  #define __UNICORE_BITOPS_H__
>
> -#define find_next_bit          __uc32_find_next_bit
> -#define find_next_zero_bit     __uc32_find_next_zero_bit
> -
> -#define find_first_bit         __uc32_find_first_bit
> -#define find_first_zero_bit    __uc32_find_first_zero_bit
> -

Is this patch really fix the build error?

If these find_*_bit macros are removed, vmlinux will have multiple
definisions of find_*_bit. Because lib/find_next_bit.c is built
unconditionally after the commit 63e424c84429903c92a0f1e9654c31ccaf6694d0
("arch: remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}".
