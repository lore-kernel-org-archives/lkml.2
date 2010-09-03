Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0ICHNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:13:33 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49966 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab0ICHNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cJNPvv9Fnyl74ZxmCjCHMAP+NJqbGTHjVhLknas/wsLevFqQmZVCXg1RCeNslHfjcC
         tllhrqyBqo9DzZzc3alrI0wK7DYc5WPq+JGdSREf+0pEJk05FMtC0yKpNdPRa7DLMslk
         zsBr3n16x6kwDXGmKe719G28wnCEBpo3rW7Ww=
MIME-Version: 1.0
In-Reply-To: <1283477451.5439.6.camel@mola>
References: <1283477451.5439.6.camel@mola>
Date: Fri, 3 Sep 2010 09:13:30 +0200
Message-ID: <AANLkTinE4G0TYSn=hmqVxXVAbTZ1cpOAXmhqg6QGY5dP@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input: stmpe-ts - remove input_free_device() in stmpe_ts_remove()
From: Luotao Fu <devtty0@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Luotao Fu <l.fu@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 3, 2010 at 3:30 AM, Axel Lin <axel.lin@gmail.com> wrote:
> No need to call input_free_device() after input_unregister_device().
>

yeah right. The device is input_unregister_device unregisters the
device already. Thx for fixing this.

Acked-by: Luotao Fu <devtty0@gmail.com>

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/input/touchscreen/stmpe-ts.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
> index 656148e..0339d1d 100644
> --- a/drivers/input/touchscreen/stmpe-ts.c
> +++ b/drivers/input/touchscreen/stmpe-ts.c
> @@ -361,7 +361,6 @@ static int __devexit stmpe_ts_remove(struct platform_device *pdev)
>        platform_set_drvdata(pdev, NULL);
>
>        input_unregister_device(ts->idev);
> -       input_free_device(ts->idev);
>
>        kfree(ts);
>
> --
> 1.7.2
>
>
>
>

cheers
Luotao Fu
