Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab0KTDC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 22:02:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52894 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab0KTDCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 22:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EBAr2idUeHgZwPiAWAqdRE9QOU1evPkgq2hkOG1nh+llWCtZmlUUlLef2z6ddctqHm
         rOCXdUk4F9xUBgELNMuacGoM60B8ScMlcbSlm0q4ppyw5hMeOZVy3BrC9OpuCJJb4vtG
         2J3E86xT8Rw0rVQ9LzXXW4Q4hjIFKQJ99iEEU=
MIME-Version: 1.0
In-Reply-To: <1290219413-21026-1-git-send-email-ccross@android.com>
References: <1290219413-21026-1-git-send-email-ccross@android.com>
Date: Sat, 20 Nov 2010 12:02:47 +0900
X-Google-Sender-Auth: BGHUOK9k9hzO8qgAPt5kxDNpx2I
Message-ID: <AANLkTi=d2xL_ZDhQtTE9Vt8SQkHGSM5oespHGT4m6Fav@mail.gmail.com>
Subject: Re: [PATCH] ARM: Fix spinlock bad magic on disabling nonboot cpu
From: Kyungmin Park <kmpark@infradead.org>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder why this patch is not merged previous rc cycles.

it's already reported by Mr. Ham (a month or more ago) and get some
acked for merge.

To Rusell, Catalin,
How to include or commit the latest kernel?

Thank you,
Kyungmin Park

On Sat, Nov 20, 2010 at 11:16 AM, Colin Cross <ccross@android.com> wrote:
> The init_mm.context.id_lock spinlock is not initialized, which
> causes a spinlock bad magic warning when nonboot cpus are disabled,
> either through hotplug or during suspend.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  arch/arm/include/asm/mmu.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/include/asm/mmu.h b/arch/arm/include/asm/mmu.h
> index 68870c7..1556f6a 100644
> --- a/arch/arm/include/asm/mmu.h
> +++ b/arch/arm/include/asm/mmu.h
> @@ -13,6 +13,8 @@ typedef struct {
>
>  #ifdef CONFIG_CPU_HAS_ASID
>  #define ASID(mm)       ((mm)->context.id & 255)
> +#define INIT_MM_CONTEXT(name)                                                 \
> +        .context.id_lock = __SPIN_LOCK_UNLOCKED(name.context.id_lock),
>  #else
>  #define ASID(mm)       (0)
>  #endif
> --
> 1.7.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
