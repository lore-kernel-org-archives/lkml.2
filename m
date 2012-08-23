Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341Ab2HWUnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:43:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52940 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932259Ab2HWUne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:43:34 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19d+M0WGBpdLN7lrZQkUH3LwJyXxtwis2u1K1lJ40
	SDOoGtQN5Vof2v
Message-ID: <503695F1.50207@gmx.de>
Date: Thu, 23 Aug 2012 20:43:29 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, spock@gentoo.org
Subject: Re: [PATCH] video:uvesafb: check the return value of kzalloc
References: <20120813100232.GA16363@udknight>
In-Reply-To: <20120813100232.GA16363@udknight>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 10:02 AM, Wang YanQing wrote:
> 
> Michal maybe forgot it merely, we should add code
> to check the return value of kzalloc to make the
> code more robust.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/uvesafb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
> index b0e2a42..2f8f82d 100644
> --- a/drivers/video/uvesafb.c
> +++ b/drivers/video/uvesafb.c
> @@ -659,6 +659,8 @@ static int __devinit uvesafb_vbe_getedid(struct uvesafb_ktask *task,
>  	task->t.flags = TF_BUF_RET | TF_BUF_ESDI;
>  	task->t.buf_len = EDID_LENGTH;
>  	task->buf = kzalloc(EDID_LENGTH, GFP_KERNEL);
> +	if (!task->buf)
> +		return -ENOMEM;
>  
>  	err = uvesafb_exec(task);
>  

