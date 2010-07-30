Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab0G3MbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 08:31:23 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:36182 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab0G3MbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 08:31:21 -0400
Message-ID: <4C52C614.4030803@bfs.de>
Date: Fri, 30 Jul 2010 14:31:16 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Beregalov <a.beregalov@gmail.com>, Tejun Heo <tj@kernel.org>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] staging: otus: check kmalloc() return value
References: <1280488080-20777-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1280488080-20777-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Kulikov Vasiliy schrieb:
> kmalloc() may fail, if so return error from zfwUsbSubmitControl().
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/staging/otus/wrap_usb.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/otus/wrap_usb.c b/drivers/staging/otus/wrap_usb.c
> index 93459ca..9f04047 100644
> --- a/drivers/staging/otus/wrap_usb.c
> +++ b/drivers/staging/otus/wrap_usb.c
> @@ -104,6 +104,11 @@ u32_t zfwUsbSubmitControl(zdev_t *dev, u8_t req, u16_t value, u16_t index,
>  
>  	if (size > 0) {
>  		buf = kmalloc(size, GFP_KERNEL);
> +		if (buf == NULL) {
> +			pr_err("zfwUsbSubmitControl() failed, "
> +				  "kmalloc() returned NULL\n");
> +			return 1;
> +		}
>  		memcpy(buf, (u8_t *)data, size);
>  	} else
>  		buf = NULL;


We had a memdup() somewhere had'nt we ?

re,
 wh
