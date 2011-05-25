Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab1EYDaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:30:20 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:54486 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755892Ab1EYDaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:30:18 -0400
Message-ID: <4DDC77A5.6020607@st.com>
Date: Wed, 25 May 2011 08:59:41 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers/misc: fix a memory leak in spear_pcie_gadget_probe
 error path
References: <1306293835.3358.1.camel@phoenix>
In-Reply-To: <1306293835.3358.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2011 8:53 AM, Axel Lin wrote:
> In the case of goto err_kzalloc, we should kfree target.
> 

Yes, you are right. Its a mistake.

Regards
Pratyush

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/misc/spear13xx_pcie_gadget.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
> index 7aded90..cfbddbe 100644
> --- a/drivers/misc/spear13xx_pcie_gadget.c
> +++ b/drivers/misc/spear13xx_pcie_gadget.c
> @@ -845,7 +845,7 @@ err_iounmap:
>  err_iounmap_app:
>  	iounmap(config->va_app_base);
>  err_kzalloc:
> -	kfree(config);
> +	kfree(target);
>  err_rel_res:
>  	release_mem_region(res1->start, resource_size(res1));
>  err_rel_res0:

