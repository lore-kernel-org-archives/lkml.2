Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0KIUnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:43:11 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59397 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0KIUnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WHRi0jwkEDIJeQbjmeY4aFOxaFZAQg8bPB/c0uLnKmYGAnVaT4aUybbDpY2nHCG3KD
         v1M5sy2jpPwklL3I2MvVh7I/s17l7B2axbTZiclPmk51gS11TLiSgtqI1q19jRapTO7S
         lQlyvKaosANQUPEjZRnqlI2cZnXDcZQ/UNlls=
MIME-Version: 1.0
In-Reply-To: <20101025235804.GA11760@outflux.net>
References: <20101025235804.GA11760@outflux.net>
Date: Tue, 9 Nov 2010 22:43:07 +0200
X-Google-Sender-Auth: RV803rItPJhwHQGSFQbtp_gpchY
Message-ID: <AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 2:58 AM, Kees Cook <kees.cook@canonical.com> wrote:
> CVE-2010-4072
>
> The old shm interface will leak a few bytes of stack contents. Explicitly
> clear structure using memset instead of C99-style initialization in case
> there are ever holes in the packing.
>
> Cc: stable <stable@kernel.org>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

This looks like a genuine bug fix but I don't see this patch in
mainline. Why is that?

> ---
>
> This was originally sent as http://lkml.org/lkml/2010/10/6/486 but was
> never taken into any tree.
>
> ---
>  ipc/shm.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 52ed77e..f943b1e 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -473,6 +473,7 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
>            {
>                struct shmid_ds out;
>
> +               memset(&out, 0, sizeof(out));
>                ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
>                out.shm_segsz   = in->shm_segsz;
>                out.shm_atime   = in->shm_atime;
> @@ -524,6 +525,7 @@ static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminf
>            {
>                struct shminfo out;
>
> +               memset(&out, 0, sizeof(out));
>                if(in->shmmax > INT_MAX)
>                        out.shmmax = INT_MAX;
>                else
> --
> 1.7.1
>
> --
> Kees Cook
> Ubuntu Security Team
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
