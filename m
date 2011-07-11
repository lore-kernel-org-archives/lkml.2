Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab1GKSjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:39:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37769 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220Ab1GKSjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:39:47 -0400
MIME-Version: 1.0
In-Reply-To: <1310370416-6322-8-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-8-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 11 Jul 2011 20:39:27 +0200
X-Google-Sender-Auth: TdnUTJhzLBK_hbQzIY1EhwfqHGM
Message-ID: <CAO+b5-qj6QJKhvXraEj=Buhp4WKmXWA3LovL7tpjbR+vW55CYw@mail.gmail.com>
Subject: Re: [PATCH 07/21] dynamic_debug: return int from ddebug_change
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 9:46 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> Alter ddebug_change to return number of matches found for query/rule.
> This lets caller know whether rule applied, and potentially what
> to do next.
>
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index bbee0aa..de2a679 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -102,8 +102,8 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
>  * the user which ddebug's were changed, or whether none
>  * were matched.
>  */
> -static void ddebug_change(const struct ddebug_query *query,
> -                          unsigned int flags, unsigned int mask)
> +static int ddebug_change(const struct ddebug_query *query,
> +                       unsigned int flags, unsigned int mask)
>  {
>        int i;
>        struct ddebug_table *dt;
> @@ -167,8 +167,7 @@ static void ddebug_change(const struct ddebug_query *query,
>        }
>        mutex_unlock(&ddebug_lock);
>
> -       if (!nfound && verbose)
> -               pr_info("no matches for query\n");
> +       return nfound;
>  }
>
>  /*
> @@ -420,6 +419,7 @@ static int ddebug_exec_query(char *query_string)
>  #define MAXWORDS 9
>        int nwords;
>        char *words[MAXWORDS];
> +       int nfound;
>
>        nwords = ddebug_tokenize(query_string, words, MAXWORDS);
>        if (nwords <= 0)
> @@ -430,7 +430,7 @@ static int ddebug_exec_query(char *query_string)
>                return -EINVAL;
>
>        /* actually go and implement the change */
> -       ddebug_change(&query, flags, mask);
> +       nfound = ddebug_change(&query, flags, mask);
>        return 0;
>  }

I still see the introduction of a dead assignment in the second half
of the above patch. After the first series had been posted you had
proposed yourself to merge this patch with the subsequent patch.
Apparently that hasn't been done yet ?

Bart.
