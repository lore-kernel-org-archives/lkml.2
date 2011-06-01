Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1FAOL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:11:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61373 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab1FAOL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1106011521160.12980@swampdragon.chaosbits.net>
References: <1306934105-6280-1-git-send-email-lucas.demarchi@profusion.mobi> <alpine.LNX.2.00.1106011521160.12980@swampdragon.chaosbits.net>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Wed, 1 Jun 2011 11:11:36 -0300
Message-ID: <BANLkTimnn8hAw7VqgbTTgheREox5DJBhcQ@mail.gmail.com>
Subject: Re: [PATCH] sysctl: remove impossible condition check
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CC'ing Al Viro ]

On Wed, Jun 1, 2011 at 10:25 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> How about compacting it even further by getting rid of the 'len' variable
> as well?
> Like this:
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  proc_sysctl.c |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index f50133c..bd7f7af 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -49,17 +49,11 @@ out:
>
>  static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
>  {
> -       int len;
>        for ( ; p->procname; p++) {
> -
> -               if (!p->procname)
> -                       continue;
> -
> -               len = strlen(p->procname);
> -               if (len != name->len)
> +               if (strlen(p->procname) != name->len)
>                        continue;
>
> -               if (memcmp(p->procname, name->name, len) != 0)
> +               if (memcmp(p->procname, name->name, name->len) != 0)
>                        continue;
>
>                /* I have a match */
>


Looking again at the code, I'm wondering if this is not actually a
bug. There might be entries with procname == NULL, meaning they are
not mirrored in /proc. What seems wrong is the condition in the for().
It should stop when all fields are 0 (meaning the end of the table)
instead of stopping when procname is NULL.

>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
>
