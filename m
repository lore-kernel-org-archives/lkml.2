Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab0FKVRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:17:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51544 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab0FKVRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZVBlSXovaoy7K6qKmpd7a2J7WJjvNKaQnK//6Sk5R0dKLDzNomh8dS88CfryWCrn5F
         t7cg/Dcmj6OeRhIcY8q6sqgenTU7VOkhZISUEVAzMWHaKaMV2Yb9wM9ZSmVH9TaUiwUe
         Je5Snxs5QTaQDhc6A/8nzjmA134KkEZe9JU+8=
MIME-Version: 1.0
In-Reply-To: <1276288869-16815-6-git-send-email-justinmattock@gmail.com>
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
	<1276288869-16815-6-git-send-email-justinmattock@gmail.com>
Date: Fri, 11 Jun 2010 23:17:44 +0200
X-Google-Sender-Auth: L7dJjqx82k10aDcb7P3iOtS-fBo
Message-ID: <AANLkTilZLOGXpZxHUklA8iHMj8HsJap2BvWMrWMmeyu3@mail.gmail.com>
Subject: Re: [PATCH 5/6]kernel:module.c variable 'nowarn' set but not used
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
> The below patch fixes a warning message
> reported by gcc 4.6.0.
>
>  CC      kernel/module.o
> kernel/module.c: In function 'add_usage_links':
> kernel/module.c:1343:6: warning: variable 'nowarn' set but not used
>
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  kernel/module.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 8c6b428..a71027a 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1340,13 +1340,9 @@ static void add_usage_links(struct module *mod)
>  {
>  #ifdef CONFIG_MODULE_UNLOAD
>        struct module_use *use;
> -       int nowarn;
> -
> +
>        mutex_lock(&module_mutex);
> -       list_for_each_entry(use, &mod->target_list, target_list) {
> -               nowarn = sysfs_create_link(use->target->holders_dir,
> -                                          &mod->mkobj.kobj, mod->name);
> -       }
> +       list_for_each_entry(use, &mod->target_list, target_list);
>        mutex_unlock(&module_mutex);
>  #endif
>  }

Also wrong, you removed the creation of the links in sysfs.

The assignment to nowarn was there to avoid another compiler warning,
as sysfs_create_link() is marked __must_check.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
