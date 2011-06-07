Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1FGDbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 23:31:00 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34453 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1FGDa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 23:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=GVaEOGbbMHAjzKYlu7uLcPL/TxwxqFKBxeJepWNXDKw5RSe6xo19c1HSIRazehHU6D
         ssWzcmoB8gLyCoeEXQLV7Pi/B1mfAmRHnAP4i7Yv82+nhivsoSMZH0E6rRbUr68OCpKe
         uNgZ+5Fa8w4a9i9PIkofHtuYV/ieT/VY2OgrE=
MIME-Version: 1.0
In-Reply-To: <1307077367-6277-1-git-send-email-eric.miao@linaro.org>
References: <1307077367-6277-1-git-send-email-eric.miao@linaro.org>
From: Eric Miao <eric.miao@linaro.org>
Date: Tue, 7 Jun 2011 11:30:36 +0800
X-Google-Sender-Auth: ymSjYU_m8pZqvlv2ExllCdklj78
Message-ID: <BANLkTi=8+Y5je60goSnr3Zucjmh+RKvQwA@mail.gmail.com>
Subject: Re: [PATCH] brd: make brd_make_request() return error code
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 1:02 PM, Eric Miao <eric.miao@linaro.org> wrote:
> brd_make_request() always returns 0, which doesn't make much sense.
>
> Signed-off-by: Eric Miao <eric.miao@linaro.org>
> ---
>  drivers/block/brd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index dba1c32..a9587ee 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -360,7 +360,7 @@ static int brd_make_request(struct request_queue *q, struct bio *bio)
>  out:
>        bio_endio(bio, err);
>
> -       return 0;
> +       return err;
>  }
>
>  #ifdef CONFIG_BLK_DEV_XIP
> --
> 1.7.4.1
>
>
