Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab2HHHMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:12:13 -0400
Received: from oyp.chewa.net ([91.121.6.101]:49002 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122Ab2HHHMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:12:12 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Organization: Remlab.net
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] cdc-phonet: Don't leak in usbpn_open
Date: Wed, 8 Aug 2012 10:12:06 +0300
User-Agent: KMail/1.13.7 (Linux/3.5.0-basile-00004-g2895365; KDE/4.8.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <alpine.LNX.2.00.1208072354030.3227@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1208072354030.3227@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208081012.07772.remi@remlab.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 8 août 2012 00:56:26 Jesper Juhl, vous avez écrit :
> We allocate memory for 'req' with usb_alloc_urb() and then test
> 'if (!req || rx_submit(pnd, req, GFP_KERNEL | __GFP_COLD))'.
> If we enter that branch due to '!req' then there is no problem. But if
> we enter the branch due to 'req' being != 0 and the 'rx_submit()' call
> being false, then we'll leak the memory we allocated.
> Deal with the leak by always calling 'usb_free_urb(req)' when entering
> the branch. If 'req' happens to be 0 then the call is harmless, if it
> is not 0 then we free the memory we allocated but don't need.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Rémi Denis-Courmont <remi@remlab.net>

> ---
>  drivers/net/usb/cdc-phonet.c | 1 +
>  1 file changed, 1 insertion(+)
> 
>   Only compile tested due to lack of hardware.

Hardware won't help you much with testing the error case anyway.

-- 
Rémi Denis-Courmont, looking for a job
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
