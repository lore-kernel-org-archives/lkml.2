Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055Ab0J1SqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:46:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44045 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab0J1SqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:46:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OSito8JmHVr9fp9A3kRvsCUgj8wwYU5dkg3glGzuO34CX5NW5nTmxjFHO/Mq9L8lJh
         3ncq/DiDwBTFAqhxB8OjG4ZwOLilyMlOO8ljxKoa6rqpbtke0K0MAf+S+sEX5MNSIYkq
         7Ude9KG5dMfkYF7QcAg3qytAGF7YqdOqvi6+4=
MIME-Version: 1.0
In-Reply-To: <20101028184223.GG30148@redhat.com>
References: <20101028184223.GG30148@redhat.com>
Date: Thu, 28 Oct 2010 20:46:18 +0200
X-Google-Sender-Auth: 6s_wig9jMsTP6cYfnvz-OQq9JoI
Message-ID: <AANLkTikOV04gMrjxwFfm0+hHft2uQ2wbTro-OrzrohnS@mail.gmail.com>
Subject: Re: [PATCH] fix amiga and atari floppy driver compile warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, hch@lst.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 20:42, Vivek Goyal <vgoyal@redhat.com> wrote:
> Geert, my crosstool don't produce warning below. I guess this has to do
> something with compiler version.
>
> - Geert noticed following warning during compilation.
>
>  drivers/block/amiflop.c:1344: warning: ‘rq’ may be used uninitialized in
>  this function
>  drivers/block/ataflop.c:1402: warning: ‘rq’ may be used uninitialized in
>  this function
>
> - Initialize rq to NULL to fix the warning. If we can't find a suitable request
>  to dispatch, this function should return NULL instead of a possibly garbage
>  pointer.

Thanks, gcc version 4.1.2 20061115 now no longer gives a warning.

> - Cross compile tested only. Don't have hardware to test it.

Floppy hardware in bad state here :-(

> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  drivers/block/amiflop.c |    2 +-
>  drivers/block/ataflop.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/drivers/block/amiflop.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/amiflop.c      2010-10-28 14:32:25.000000000 -0400
> +++ linux-2.6/drivers/block/amiflop.c   2010-10-28 14:34:11.000000000 -0400
> @@ -1341,7 +1341,7 @@ static struct request *set_next_request(
>  {
>        struct request_queue *q;
>        int cnt = FD_MAX_UNITS;
> -       struct request *rq;
> +       struct request *rq = NULL;
>
>        /* Find next queue we can dispatch from */
>        fdc_queue = fdc_queue + 1;
> Index: linux-2.6/drivers/block/ataflop.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/ataflop.c      2010-10-28 14:31:21.000000000 -0400
> +++ linux-2.6/drivers/block/ataflop.c   2010-10-28 14:33:58.000000000 -0400
> @@ -1399,7 +1399,7 @@ static struct request *set_next_request(
>  {
>        struct request_queue *q;
>        int old_pos = fdc_queue;
> -       struct request *rq;
> +       struct request *rq = NULL;
>
>        do {
>                q = unit[fdc_queue].disk->queue;
>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
