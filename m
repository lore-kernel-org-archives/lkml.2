Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0FSIGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:06:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35934 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab0FSIGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f44GdhN9UMbTEOIenDtJQXxIH0ZwAQOON0+16Z4vmu2e31Hu/DKNx7X/L5zISUyImk
         L5kdjS2g7TdlKh0ZTMAXp7SdLDQdRLK9oI8gWnFVOrRT/ePpftOQXkItuBwgYOg1ycii
         9l81jXWD1FFuPH0QjhCx5Ae372bGar7Gnb5qc=
MIME-Version: 1.0
In-Reply-To: <4C1C4B55.8070209@gmail.com>
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
	<1276288869-16815-3-git-send-email-justinmattock@gmail.com>
	<AANLkTildzUcfd6GghHbO53ebPAc4m4BahJrXUr8B7SQF@mail.gmail.com>
	<4C1C4B55.8070209@gmail.com>
Date: Sat, 19 Jun 2010 10:06:00 +0200
X-Google-Sender-Auth: nxFKtdK3CPtYKnmVivUOFV8y1LY
Message-ID: <AANLkTimqF_gsNxddtUIjQwBaju2N4B7FyNTXoy5RArk4@mail.gmail.com>
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

On Sat, Jun 19, 2010 at 06:45, Justin P. Mattock
<justinmattock@gmail.com> wrote:
>> This is not dead code. NLMSG_NEW() sets up an nlmsg in ab->skb.
>> If you remove the code, it's no longer initialized.
>
> I played around with this code some more, but am still getting confused with
> nlmsg_new and NLMSG_NEW. if I remove the nlmsghdr struct I can get a clean

nlmsg_new() allocates a new nlmsg.
NLMSG_NEW() initializes a nlmsg inside an already allocated skbuff.

> build without a warning, but still am a bit confused.
>
> here is an updated patch let me know if it still needs work..
> or if it's legit I can resend this.

Looks OK to me, thanks!

> From 7515a08ba921d3beed33fa5c6b1fbe59cf52e069 Mon Sep 17 00:00:00 2001
> From: Justin P. Mattock <justinmattock@gmail.com>
> Date: Fri, 18 Jun 2010 19:44:30 -0700
> Subject: [PATCH 4/4] audit
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  kernel/audit.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index c71bd26..1d51258 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1041,7 +1041,6 @@ static struct audit_buffer * audit_buffer_alloc(struct
> audit_context *ctx,
>  {
>        unsigned long flags;
>        struct audit_buffer *ab = NULL;
> -       struct nlmsghdr *nlh;
>
>        spin_lock_irqsave(&audit_freelist_lock, flags);
>        if (!list_empty(&audit_freelist)) {
> @@ -1065,7 +1064,7 @@ static struct audit_buffer * audit_buffer_alloc(struct
> audit_context *ctx,
>        if (!ab->skb)
>                goto nlmsg_failure;
>
> -       nlh = NLMSG_NEW(ab->skb, 0, 0, type, 0, 0);
> +       NLMSG_NEW(ab->skb, 0, 0, type, 0, 0);
>
>        return ab;
>
> --
> 1.7.1.rc1.21.gf3bd6

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
