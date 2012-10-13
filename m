Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2JMDy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 23:54:57 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:46343 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2JMDy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 23:54:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0811091803320.23782@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.0811091803320.23782@swampdragon.chaosbits.net>
Date: Sat, 13 Oct 2012 00:54:55 -0300
Message-ID: <CALF0-+Vtmwu9rCc9BYiDx2O2GQWezK40BYR2LP_ve2YjCt=Afg@mail.gmail.com>
Subject: Re: [PATCH] [media] stk1160: Remove dead code from stk1160_i2c_read_reg()
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 9, 2008 at 2:04 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> There are two checks for 'rc' being less than zero with no change to
> 'rc' between the two, so the second is just dead code - remove it.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/media/usb/stk1160/stk1160-i2c.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
> index 176ac93..035cf8c 100644
> --- a/drivers/media/usb/stk1160/stk1160-i2c.c
> +++ b/drivers/media/usb/stk1160/stk1160-i2c.c
> @@ -117,9 +117,6 @@ static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
>                 return rc;
>
>         stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
> -       if (rc < 0)
> -               return rc;
> -
>         return 0;
>  }
>

Thanks for doing this. Wouldn't you like to save stk1160_read_reg
return code to rc, instead of this?

    Ezequiel
