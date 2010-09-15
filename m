Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0IOXpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 19:45:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41304 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753391Ab0IOXpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 19:45:39 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/0hG9QtHf0SLCd89NDlTPLRYncaON7iqDPybfmYF
	fAxvLVOSX2JiwB
Message-ID: <4C915A9E.408@gmx.de>
Date: Thu, 16 Sep 2010 01:45:34 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: JosephChan@via.com.tw, ScottFang@viatech.com.cn,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org, stable@kernel.org
Subject: Re: [PATCH v2] drivers/video/via/ioctl.c: prevent reading uninitialized
 stack memory
References: <1284592104.10727.12.camel@dan>
In-Reply-To: <1284592104.10727.12.camel@dan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Rosenberg schrieb:
> Disregard previous version, which had a typo and wouldn't compile.
> Also, math is fun: the ioctl allows reading of 1968 BITS = 246 bytes,
> not 1968 bytes as previously reported.

Thanks, I will take care of getting it in mainline as soon as possible,

Florian Tobias Schandinat

> 
> The VIAFB_GET_INFO device ioctl allows unprivileged users to read 246
> bytes of uninitialized stack memory, because the "reserved" member of
> the viafb_ioctl_info struct declared on the stack is not altered or
> zeroed before being copied back to the user.  This patch takes care of
> it.
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> 
> --- linux-2.6.35.4.orig/drivers/video/via/ioctl.c	2010-08-26 19:47:12.000000000 -0400
> +++ linux-2.6.35.4/drivers/video/via/ioctl.c	2010-09-15 11:53:29.997375748 -0400
> @@ -25,6 +25,8 @@ int viafb_ioctl_get_viafb_info(u_long ar
>  {
>  	struct viafb_ioctl_info viainfo;
>  
> +	memset(&viainfo, 0, sizeof(struct viafb_ioctl_info));
> +
>  	viainfo.viafb_id = VIAID;
>  	viainfo.vendor_id = PCI_VIA_VENDOR_ID;
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

