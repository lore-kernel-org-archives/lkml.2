Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2LTQkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:40:15 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:42719 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2LTQkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:40:11 -0500
MIME-Version: 1.0
In-Reply-To: <1354971050-5784-1-git-send-email-sasha.levin@oracle.com>
References: <1354971050-5784-1-git-send-email-sasha.levin@oracle.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 20 Dec 2012 11:39:47 -0500
Message-ID: <CA+1xoqdZ06HdshtX0FET0t1iQF8cOFBrXYOkvR-XHV0UDJY8hQ@mail.gmail.com>
Subject: Re: [PATCH] rc-core: don't return from store_protocols without
 releasing device mutex
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mchehab@redhat.com, david@hardeman.nu, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Sat, Dec 8, 2012 at 7:50 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Commit c003ab1b ("[media] rc-core: add separate defines for protocol bitmaps
> and numbers") has introduced a bug which allows store_protocols() to return
> without releasing the device mutex it's holding.
>
> Doing that would cause infinite hangs waiting on device mutex next time
> around.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/media/rc/rc-main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 601d1ac1..0510f4d 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -890,7 +890,8 @@ static ssize_t store_protocols(struct device *device,
>
>                 if (i == ARRAY_SIZE(proto_names)) {
>                         IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
> -                       return -EINVAL;
> +                       ret = -EINVAL;
> +                       goto out;
>                 }
>
>                 count++;
> --
> 1.8.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
