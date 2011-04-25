Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab1DYUcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:32:06 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:58756 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab1DYUcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:32:02 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjDUQEjn+/g==
X-RZG-CLASS-ID: mo00
Date: Mon, 25 Apr 2011 22:31:58 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 112/173] Input: xen-kbdfront - advertise either absolute
 or relative coordinates
Message-ID: <20110425203158.GA8427@aepfle.de>
References: <46075c3a3ef08be6d70339617d6afc98@local>
 <20110425200237.859884245@pcw.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110425200237.859884245@pcw.home.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, Willy Tarreau wrote:

> 2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

These two hunks have to be removed from the patch.
If the guest is suspended/resumed the guest has to renegotiate with the
new qemu-dm process and set the request-abs-pointer property again.

Olaf

> @@ -267,7 +281,7 @@
>  				   enum xenbus_state backend_state)
>  {
>  	struct xenkbd_info *info = dev->dev.driver_data;
> -	int ret, val;
> +	int val;
>  
>  	switch (backend_state) {
>  	case XenbusStateInitialising:
> @@ -278,17 +292,6 @@
>  
>  	case XenbusStateInitWait:
>  InitWait:
> -		ret = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
> -				   "feature-abs-pointer", "%d", &val);
> -		if (ret < 0)
> -			val = 0;
> -		if (val) {
> -			ret = xenbus_printf(XBT_NIL, info->xbdev->nodename,
> -					    "request-abs-pointer", "1");
> -			if (ret)
> -				printk(KERN_WARNING
> -				       "xenkbd: can't request abs-pointer");
> -		}
>  		xenbus_switch_state(dev, XenbusStateConnected);
>  		break;
>  
> 
> 
