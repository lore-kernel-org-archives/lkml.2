Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab1JGD3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:29:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46606 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1JGD3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:29:54 -0400
MIME-Version: 1.0
In-Reply-To: <87lisype1v.fsf@faui43f.informatik.uni-erlangen.de>
References: <87lisype1v.fsf@faui43f.informatik.uni-erlangen.de>
Date: Thu, 6 Oct 2011 23:29:50 -0400
Message-ID: <CACqU3MWZuqgpxG7FSvr2LkqTqwF-gQM8hQSnTTpHpcWT2LHGNA@mail.gmail.com>
Subject: Re: [PATCH] kconfig: Fix checking return value of 'fwrite'
From: Arnaud Lacombe <lacombar@gmail.com>
To: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
Cc: linux-kbuild@vger.kernel.org, Jean Sacren <sakiwit@gmail.com>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        vamos-dev@lists.informatik.uni-erlangen.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/10/6 Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>:
> fwrite indicates '1' written member if a zero-length string is written.
you forgot the "Signed-off-by: " part :)

 - Arnaud

> ---
>  scripts/kconfig/lkc.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
> index b633bdb..727d265 100644
> --- a/scripts/kconfig/lkc.h
> +++ b/scripts/kconfig/lkc.h
> @@ -90,7 +90,7 @@ struct conf_printer {
>  /* confdata.c and expr.c */
>  static inline void xfwrite(const void *str, size_t len, size_t count, FILE *out)
>  {
> -       if (fwrite(str, len, count, out) < count)
> +       if (len > 0 && fwrite(str, len, count, out) < count)
>                fprintf(stderr, "\nError in writing or end of file.\n");
>  }
>
> --
> 1.7.0.4
>
> --
> Reinhard Tartler                     Department of Computer Science IV
> Martensstr 1, 91058 Erlangen Germany, University of Erlangen-Nuremberg
>            http://www4.informatik.uni-erlangen.de/~tartler
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
