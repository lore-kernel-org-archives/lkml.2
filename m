Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab1LLMvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:51:25 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65278 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1LLMvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:51:24 -0500
MIME-Version: 1.0
In-Reply-To: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
Date: Mon, 12 Dec 2011 13:51:22 +0100
Message-ID: <CAAfyv35=J_BhxXBF-FrV0DfW1h6eo6MxXMpB2d4+WseujXAeoA@mail.gmail.com>
Subject: Re: [PATCH] kref: add function for reading kref value
From: Belisko Marek <marek.belisko@gmail.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 1:44 PM, Daniel Baluta <dbaluta@ixiacom.com> wrote:
> We can easily get kref refcount value by accesing
> kref->refcount but it is better to have a function
> for this.
>
> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
> ---
>  include/linux/kref.h |    1 +
>  lib/kref.c           |    9 +++++++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/kref.h b/include/linux/kref.h
> index d4a62ab..cd1b04a 100644
> --- a/include/linux/kref.h
> +++ b/include/linux/kref.h
> @@ -22,6 +22,7 @@ struct kref {
>  };
>
>  void kref_init(struct kref *kref);
> +atomic_t kref_read(struct kref *kref);
>  void kref_get(struct kref *kref);
>  int kref_put(struct kref *kref, void (*release) (struct kref *kref));
>  int kref_sub(struct kref *kref, unsigned int count,
> diff --git a/lib/kref.c b/lib/kref.c
> index 3efb882..48aaf2a 100644
> --- a/lib/kref.c
> +++ b/lib/kref.c
> @@ -25,6 +25,15 @@ void kref_init(struct kref *kref)
>        smp_mb();
>  }
>
> +/**
> + * kref_read - read refcount for object
> + * @kref: object.
> + */
> +void kref_read(struct kref *kref)
> +{
> +       return atomic_read(&kref->refcount);
> +}
Return void? Shouldn't be: atomic_t. Did you compile your code before
submission???
> +
>  /**
>  * kref_get - increment refcount for object.
>  * @kref: object.
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
