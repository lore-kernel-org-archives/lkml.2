Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab1CSURz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 16:17:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63465 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab1CSURv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 16:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UADjPVDpvZOZFDZ4ko23dLmbS/Niy9xQrxQq7NjhEMw2HO1iKz9vwxS2MhWaQkqhOw
         SYGW0xecMuorhFbz/cwPszvuZAjNHYXxSYrfE68mcDiWNWBihFfEyN88GEe32JJ1ESBp
         lFGRX51/ZHhjXZoc0FB2i7Io9oVFyeAUIVzr8=
MIME-Version: 1.0
In-Reply-To: <1298969484-16199-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1298969484-16199-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Date: Sat, 19 Mar 2011 21:12:04 +0100
X-Google-Sender-Auth: 24OJjwTm0DkLAL1-l8pZ17oaVYo
Message-ID: <AANLkTincqAPaXGysa_y5vw8Wj8dru9MCxXvyqETojuki@mail.gmail.com>
Subject: Re: [PATCH 6/6] net/9p: Fix compile warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These warnings?

net/9p/trans_common.c:45: warning: cast from pointer to integer of
different size
net/9p/trans_common.c:46: warning: cast from pointer to integer of
different size
net/9p/trans_common.c:72: warning: comparison of distinct pointer
types lacks a cast

On Tue, Mar 1, 2011 at 09:51, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  net/9p/trans_common.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
> index d62b9aa..ca55e3b 100644
> --- a/net/9p/trans_common.c
> +++ b/net/9p/trans_common.c
> @@ -42,8 +42,8 @@ int
>  p9_nr_pages(struct p9_req_t *req)
>  {
>        int start_page, end_page;

In addition, the values may not fit in an int on 64-bit. Better use
'unsigned long'.

> -       start_page =  (unsigned long long)req->tc->pubuf >> PAGE_SHIFT;
> -       end_page = ((unsigned long long)req->tc->pubuf + req->tc->pbuf_size +
> +       start_page =  (unsigned long)req->tc->pubuf >> PAGE_SHIFT;
> +       end_page = ((unsigned long)req->tc->pubuf + req->tc->pbuf_size +
>                        PAGE_SIZE - 1) >> PAGE_SHIFT;
>        return end_page - start_page;
>  }
> @@ -69,8 +69,8 @@ p9_payload_gup(struct p9_req_t *req, size_t *pdata_off, int *pdata_len,
>        *pdata_off = (size_t)req->tc->pubuf & (PAGE_SIZE-1);
>
>        if (*pdata_off)
> -               first_page_bytes = min((PAGE_SIZE - *pdata_off),
> -                               req->tc->pbuf_size);
> +               first_page_bytes = min(((size_t)PAGE_SIZE - *pdata_off),
> +                                      req->tc->pbuf_size);
>
>        rpinfo = req->tc->private;
>        pdata_mapped_pages = get_user_pages_fast((unsigned long)req->tc->pubuf,
> --
> 1.7.1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
