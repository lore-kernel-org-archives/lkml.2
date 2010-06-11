Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab0FKVOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:14:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50081 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab0FKVOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:14:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I/3VyqVm1K49pqd8RMPgh2QSF01p3FFYR+/jhvSlFBczi1dcX8cWT+wGnTthRI+0Mz
         djj9mtBC+74mBkiXZ048fGZtx7Gl4ItDNXTOSzYDJS+p4LYGG6IlXbfSnP4ZgczoF7Li
         bsdZ6V464PSbp776G01NXrR1c2TrfWvHAlgFk=
MIME-Version: 1.0
In-Reply-To: <1276288869-16815-3-git-send-email-justinmattock@gmail.com>
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
	<1276288869-16815-3-git-send-email-justinmattock@gmail.com>
Date: Fri, 11 Jun 2010 23:14:48 +0200
X-Google-Sender-Auth: b2r1RCUlCV2S_ZEm3rxUqctmS9M
Message-ID: <AANLkTildzUcfd6GghHbO53ebPAc4m4BahJrXUr8B7SQF@mail.gmail.com>
Subject: Re: [PATCH 2/6]kernel:audit.c Fix warning: variable 'nlh' set but not 
	used
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       zippel@linux-m68k.org, linux-fsdevel@vger.kernel.org,
       rusty@rustcorp.com.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 22:41, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> Removing dead code(hopefully), fixes a warning

This is not dead code. NLMSG_NEW() sets up an nlmsg in ab->skb.
If you remove the code, it's no longer initialized.

> when compiling the kernel.
>
>  CC      kernel/audit.o
> kernel/audit.c: In function 'audit_buffer_alloc':
> kernel/audit.c:1044:19: warning: variable 'nlh' set but not used
>  CC      kernel/auditfilter.o
>
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  kernel/audit.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index c71bd26..783d958 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1041,8 +1041,7 @@ static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
>  {
>        unsigned long flags;
>        struct audit_buffer *ab = NULL;
> -       struct nlmsghdr *nlh;
> -
> +
>        spin_lock_irqsave(&audit_freelist_lock, flags);
>        if (!list_empty(&audit_freelist)) {
>                ab = list_entry(audit_freelist.next,
> @@ -1065,8 +1064,7 @@ static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
>        if (!ab->skb)
>                goto nlmsg_failure;
>
> -       nlh = NLMSG_NEW(ab->skb, 0, 0, type, 0, 0);
> -
> +
>        return ab;
>
>  nlmsg_failure:                  /* Used by NLMSG_NEW */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
