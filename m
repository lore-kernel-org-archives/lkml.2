Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0HJLf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 07:35:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33276 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0HJLfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 07:35:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lBLC3zcxIjkW7Iep0cR81UzYFEz0pmQEMebqLkbwxePhA/lnnkBoanP5xjQGBmJ4ip
         qu4FQ6QsUfxba6nNq+UZPu4NRwSPFX1mwnA4KpWAjabgetFFpdwcyVPeQvmcK0ISrCDI
         3MZ8QtEOzyRaOh143KKYbGGYHnh/Soq6l8Iuo=
MIME-Version: 1.0
In-Reply-To: <1281437552.2063.431.camel@alex-desktop>
References: <1281010151.2063.8.camel@alex-desktop>
	<AANLkTi=YessPd6cHhLdveyrSq_TcY1Vx1LxpCNLthEJG@mail.gmail.com>
	<1281437552.2063.431.camel@alex-desktop>
Date: Tue, 10 Aug 2010 14:35:48 +0300
Message-ID: <AANLkTi=UfzGay5XQKMpPCZTSO5SJ1jDknqwayhrEZJO0@mail.gmail.com>
Subject: Re: [PATCHv3] fixed resource leak in scripts/mod/modpost.c
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trevor Keith <tsrk@tsrk.net>, Rusty Russell <rusty@rustcorp.com.au>,
        ext Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 1:52 PM, Alexey Fomenko
<ext-alexey.fomenko@nokia.com> wrote:
> From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
>
> sec2annotation() returns malloc'ed buffer directly to printf as an
> argument. Patch lets free this buffer after printing. Preventing ops
> while freeing the buffer by changing return const str to return
> strdup empty line.
>
> Signed-off-by: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
> ---
>  scripts/mod/modpost.c |   58 ++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 42 insertions(+), 16 deletions(-)
>
> diff -ur linux-2.6.35/scripts/mod/modpost.c linux-2.6.35_b/scripts/mod/modpost.c
> --- linux-2.6.35/scripts/mod/modpost.c  2010-08-10 12:11:03.854528620 +0300
> +++ linux-2.6.35_b/scripts/mod/modpost.c        2010-08-10 12:11:25.174529109 +0300
> @@ -1165,9 +1165,9 @@
>                        strcat(p, "data ");
>                else
>                        strcat(p, " ");
> -               return r; /* we leak her but we do not care */
> +               return r;
Here is the extra tail whitespace.

> @@ -1283,11 +1301,15 @@
>                "uses functionality in the exit path.\n"
>                "The fix is often to remove the %sannotation of\n"
>                "%s%s so it may be used outside an exit section.\n",
> -               from, sec2annotation(fromsec), fromsym, from_p,
> -               to, sec2annotation(tosec), tosym, to_p,
> +               from, prl_from, fromsym, from_p,
> +               to, prl_to, tosym, to_p,
>                sec2annotation(tosec), tosym, to_p);
^^^^^^^^^^^^^^^^^^^^^^ missed change


Acked-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
(after fixing above issues)

-- 
With Best Regards,
Andy Shevchenko
