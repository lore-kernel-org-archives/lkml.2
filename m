Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab2LJJlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:41:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25177 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2LJJla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:41:30 -0500
Date: Mon, 10 Dec 2012 12:41:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        greg@kroah.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] rtl8712: replace min with min_t
Message-ID: <20121210094108.GQ6568@mwanda>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
 <1355048110-10859-4-git-send-email-przemo@firszt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355048110-10859-4-git-send-email-przemo@firszt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2012 at 10:15:09AM +0000, Przemo Firszt wrote:
> A clean up change suggested by checkpatch.pl
> 
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> ---
>  drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index cdb51d7..b131b61 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -188,8 +188,7 @@ static inline char *translate_scan(struct _adapter *padapter,
>  	/* Add the ESSID */
>  	iwe.cmd = SIOCGIWESSID;
>  	iwe.u.data.flags = 1;
> -	iwe.u.data.length = (u16)min((u16)pnetwork->network.Ssid.SsidLength,
> -			    (u16)32);
> +	iwe.u.data.length = min_t(u16, pnetwork->network.Ssid.SsidLength, 32);

pnetwork->network.Ssid.SsidLength is a u32 so it would be better to
not truncate the upper bits away.  It's not going to cause a
problem, but its slightly messy.

This is a common problem where people take the type of
iwe.u.data.length and cast to that instead of considering the types
for the data they are comparing.

regards,
dan carpenter

