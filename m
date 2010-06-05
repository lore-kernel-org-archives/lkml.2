Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab0FEAAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 20:00:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59996 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab0FEAAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 20:00:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=S/9T8EtrG++apas4S59jk4jSjRG+xkmf1zScDmrE7hsBuVZf4CPwNTu4Pg2ULhz8SO
         7lqNii/fEGfQll0o3/JXrMfUqwzvBqstAuQgOY3q5Je1M8WpS/Y+Um9YOCOW3kugbpZd
         rTT4wQc0ECNTG+90VCXyvAG1IGBfsaXJ1cTLc=
MIME-Version: 1.0
In-Reply-To: <20100604211025.GA17881@os.inf.tu-dresden.de>
References: <20100604211025.GA17881@os.inf.tu-dresden.de>
Date: Fri, 4 Jun 2010 17:00:02 -0700
X-Google-Sender-Auth: zzN7G76orEWy6TkkR7-JsWiKQQc
Message-ID: <AANLkTimDkEqpGNDkDSy7e8s_ZnCnVuppa6Ut-SLEoHWE@mail.gmail.com>
Subject: Re: [PATCH] early_res: fix check in free_early_partial
From: Yinghai Lu <yinghai@kernel.org>
To: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 2:10 PM, Adam Lackorzynski
<adam@os.inf.tu-dresden.de> wrote:
> free_early_partial must check the returned region of find_overlapped_early()
> whether it is a region at all. Otherwise the function will indefinitely
> loop.

do you have that hang really?

that stage we should not have blank slot in the middle.

Thanks

Yinghai Lu

>
> Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
> ---
>  kernel/early_res.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/early_res.c b/kernel/early_res.c
> index 31aa933..9afcb4c 100644
> --- a/kernel/early_res.c
> +++ b/kernel/early_res.c
> @@ -341,10 +341,11 @@ void __init free_early_partial(u64 start, u64 end)
>
>  try_next:
>        i = find_overlapped_early(start, end);
> -       if (i >= max_early_res)
> +       r = &early_res[i];
> +
> +       if (i >= max_early_res || !r->end)
>                return;
>
> -       r = &early_res[i];
>        /* hole ? */
>        if (r->end >= end && r->start <= start) {
>                drop_range_partial(i, start, end);
> --
> 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
