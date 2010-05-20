Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0ETRCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:02:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40062 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab0ETRCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:02:43 -0400
Message-ID: <4BF56AFF.1010406@ru.mvista.com>
Date: Thu, 20 May 2010 21:01:51 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
CC: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] USB: gadget: f_fs: use usb_string_ids_n()
References: <cover.1274187425.git.m.nazarewicz@samsung.com> <6577770c2519efd2193ed6454dcd895472bba404.1274187425.git.m.nazarewicz@samsung.com> <f888a55a4bd4d631c0d36e8463bb5bbb8e9d7a3d.1274187425.git.m.nazarewicz@samsung.com> <d38bd775a3b1c58255e19fda826cae7aa66a0a20.1274187425.git.m.nazarewicz@samsung.com> <906519813412e3970e06499f0dbe2823280ed54a.1274187425.git.m.nazarewicz@samsung.com> <a2865e8e9c3a9a305833ffea9caaec661082d5cf.1274187425.git.m.nazarewicz@samsung.com>
In-Reply-To: <a2865e8e9c3a9a305833ffea9caaec661082d5cf.1274187425.git.m.nazarewicz@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Michal Nazarewicz wrote:

> Use usb_string_ids_n() function to simplify string ids
> registeration.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
[...]
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 3fe120f..ffc0001 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
[...]
> @@ -1393,25 +1396,17 @@ static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
>  	ffs->ep0req->complete = ffs_ep0_complete;
>  	ffs->ep0req->context = ffs;
>  
> -	/* Get strings identifiers */
> -	for (count = ffs->strings_count, i = 0; i < count; ++i) {
> -		struct usb_gadget_strings **lang;
> -
> -		int id = usb_string_id(cdev);
> -		if (unlikely(id < 0)) {
> -			usb_ep_free_request(cdev->gadget->ep0, ffs->ep0req);
> -			ffs->ep0req = NULL;
> -			return id;
> +	lang = ffs->stringtabs;
> +	while (*lang) {
> +		struct usb_string *str = (*lang)->strings;
> +		int id = first_id;
> +		for (; str->s; ++id, ++str) {
> +			str->id = id;
>  		}

    {} not needed here.

WBR, Sergei
