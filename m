Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2ITOkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:40:10 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:52547 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab2ITOkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:40:08 -0400
Date: Thu, 20 Sep 2012 16:40:01 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/s390/char/monreader.c: fix error return
 code
Message-ID: <20120920164001.50a4305c@thinkpad>
In-Reply-To: <1347869521-2470-1-git-send-email-peter.senna@gmail.com>
References: <1347869521-2470-1-git-send-email-peter.senna@gmail.com>
Reply-To: gerald.schaefer@de.ibm.com
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12092014-0542-0000-0000-00000310045B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012 10:12:00 +0200
Peter Senna Tschudin <peter.senna@gmail.com> wrote:

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
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  drivers/s390/char/monreader.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/char/monreader.c b/drivers/s390/char/monreader.c
> index 5b8b859..f4ff515 100644
> --- a/drivers/s390/char/monreader.c
> +++ b/drivers/s390/char/monreader.c
> @@ -571,8 +571,11 @@ static int __init mon_init(void)
>  	if (rc)
>  		goto out_iucv;
>  	monreader_device = kzalloc(sizeof(struct device), GFP_KERNEL);
> -	if (!monreader_device)
> +	if (!monreader_device) {
> +		rc = -ENOMEM;
>  		goto out_driver;
> +	}
> +
>  	dev_set_name(monreader_device, "monreader-dev");
>  	monreader_device->bus = &iucv_bus;
>  	monreader_device->parent = iucv_root;

Applied, thanks!

