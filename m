Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2CPSGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:06:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32933 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753471Ab2CPSGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:06:45 -0400
Message-ID: <1331921203.11368.4.camel@joe2Laptop>
Subject: Re: [PATCH V2] Enhance logging for Shared Transport - TI driver
From: Joe Perches <joe@perches.com>
To: alexandrasava18@gmail.com
Cc: gregkh@linuxfoundation.org, pavan_savoy@ti.com, mgherzan@gmail.com,
        daniel.baluta@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 11:06:43 -0700
In-Reply-To: <9ea802684dee3b531a19f93424c77e22a955dd54.1331920050.git.alexandrasava18@gmail.com>
References: <y>
	 <9ea802684dee3b531a19f93424c77e22a955dd54.1331920050.git.alexandrasava18@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 19:58 +0200, alexandrasava18@gmail.com wrote:
> From: Alexandra Sava <alexandrasava18@gmail.com>
> * reduced verbosity
> * replaced pr_* with dev_* where possible

pr_<level> and dev_<level> formats should end in with
a "\n" newline.

> diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
[]
> @@ -19,7 +19,6 @@
>   *
>   */
>  
> -#define pr_fmt(fmt)	"(stc): " fmt

It'd be useful to keep the #define pr_fmt
perhaps as
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
for each file so that the pr_<level> uses
are prefixed by subsystem.

> @@ -122,12 +119,12 @@ void st_send_frame(unsigned char chnl_id, struct st_data_s *st_gdata)
>  			(st_gdata->list[chnl_id]->recv
>  			(st_gdata->list[chnl_id]->priv_data, st_gdata->rx_skb)
>  			     != 0)) {
> -			pr_err(" proto stack %d's ->recv failed", chnl_id);
> +			pr_err("proto stack %d's ->recv failed", chnl_id);

			pr_err(proto stack %d's ->recv failed\n", chnl_id);

>  			kfree_skb(st_gdata->rx_skb);
>  			return;
>  		}
>  	} else {
> -		pr_err(" proto stack %d's ->recv null", chnl_id);
> +		pr_err("proto stack %d's ->recv null", chnl_id);

		pr_err("proto stack %d's ->recv null\n", chnl_id);
etc...


