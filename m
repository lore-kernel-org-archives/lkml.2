Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab1DES5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:57:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42484 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1DES5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lp7yiFw5evLCijAT0Pufk4v9O6xHOaCmWYjQ88SCrvHwhWyvna/pFwcLVpFY4Ok+ZH
         BEjRan7fkdnYc6/TmhdsM7KFZCbfNHwFqs6QnQ4hshU5QsdGUJQ9y7hq3CLI3bXUTJ62
         irBYX2wSG47fwVdiQeUAnIRjmpeBC1A56mWcQ=
MIME-Version: 1.0
In-Reply-To: <1302015561-21047-2-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	<1302015561-21047-2-git-send-email-mmarek@suse.cz>
Date: Tue, 5 Apr 2011 14:57:44 -0400
Message-ID: <BANLkTinwKzasKmB_fFzXd+W7F6GGuPO6+g@mail.gmail.com>
Subject: Re: [PATCH 01/34] kconfig: Do not record timestamp in auto.conf and autoconf.h
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 5, 2011 at 10:58 AM, Michal Marek <mmarek@suse.cz> wrote:
> Timestamps in file data are useless and there is already one in .config
>
hum, shouldn't this be tunable via KCONFIG_NOTIMESTAMP ? This might be
useful to know when the file was generated, independently of the
.config, as conf_write() and conf_write_autoconf() are independent
from one another.

 - Arnaud

> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/kconfig/confdata.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index 61c35bf..834eecb 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -784,7 +784,6 @@ int conf_write_autoconf(void)
>        const char *str;
>        const char *name;
>        FILE *out, *tristate, *out_h;
> -       time_t now;
>        int i;
>
>        sym_clear_all_valid();
> @@ -811,22 +810,19 @@ int conf_write_autoconf(void)
>                return 1;
>        }
>
> -       time(&now);
>        fprintf(out, "#\n"
>                     "# Automatically generated make config: don't edit\n"
>                     "# %s\n"
> -                    "# %s"
>                     "#\n",
> -                    rootmenu.prompt->text, ctime(&now));
> +                    rootmenu.prompt->text);
>        fprintf(tristate, "#\n"
>                          "# Automatically generated - do not edit\n"
>                          "\n");
>        fprintf(out_h, "/*\n"
>                       " * Automatically generated C config: don't edit\n"
>                       " * %s\n"
> -                      " * %s"
>                       " */\n",
> -                      rootmenu.prompt->text, ctime(&now));
> +                      rootmenu.prompt->text);
>
>        for_all_symbols(i, sym) {
>                sym_calc_value(sym);
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
