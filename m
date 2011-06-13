Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1FMNdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:33:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65371 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1FMNd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c4/OQgzZpefh1lf0NsCERJZmFmJbJBz6yi1BDZJGtyLpFs0zyxFq6XxcddVE1csh5P
         4JmM9Euvi4s3mKd0XB9XdkyiztaaOsk/v6Yya0HZhejAbo0dxm4m1tmcDs9H1QB2W3Fz
         5uQ8YCjXaSCSOThEIg3hAp3mCX4AJQ4Yh4k9c=
MIME-Version: 1.0
In-Reply-To: <20110613115116.7843.49566.stgit@localhost6>
References: <20110613115116.7843.49566.stgit@localhost6>
Date: Mon, 13 Jun 2011 14:33:28 +0100
Message-ID: <BANLkTikWTHuRh0kqy+sr3n1UCtdVpdui=w@mail.gmail.com>
Subject: Re: [PATCH] efifb: fix device unregister on error path
From: Maxin B John <maxin.john@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Peter Jones <pjones@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 13, 2011 at 12:51 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> Argument of platform_device_unregister() should be efifb_device, not efifb_driver.
> bug in v3.0-rc1-57-gbb8b266
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  drivers/video/efifb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> index 69c49df..784139a 100644
> --- a/drivers/video/efifb.c
> +++ b/drivers/video/efifb.c
> @@ -541,7 +541,7 @@ static int __init efifb_init(void)
>         */
>        ret = platform_driver_probe(&efifb_driver, efifb_probe);
>        if (ret) {
> -               platform_device_unregister(&efifb_driver);
> +               platform_device_unregister(&efifb_device);
>                return ret;
>        }

The same issue is present in this thread:

https://lkml.org/lkml/2011/6/12/34
