Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2IGQVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:21:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65431 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2IGQVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:21:17 -0400
MIME-Version: 1.0
In-Reply-To: <1346945041-26676-3-git-send-email-peter.senna@gmail.com>
References: <1346945041-26676-3-git-send-email-peter.senna@gmail.com>
Date: Fri, 7 Sep 2012 13:21:16 -0300
Message-ID: <CALF0-+Wy47kwSLnQtktXwi_JQ86b6-9RjL02hu5W9xYtqaYi6g@mail.gmail.com>
Subject: Re: [PATCH 11/14] drivers/media/usb/stk1160/stk1160-i2c.c: fix error
 return code
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 12:23 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
>
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
>
> // </smpl>
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>
> ---
>  drivers/media/usb/stk1160/stk1160-i2c.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
> index 176ac93..850cf28 100644
> --- a/drivers/media/usb/stk1160/stk1160-i2c.c
> +++ b/drivers/media/usb/stk1160/stk1160-i2c.c
> @@ -116,7 +116,7 @@ static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
>         if (rc < 0)
>                 return rc;
>
> -       stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
> +       rc = stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
>         if (rc < 0)
>                 return rc;
>
>
> --

Acked-by: Ezequiel Garcia <elezegarcia@gmail.com>
