Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2ICTkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:40:06 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:36752
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756327Ab2ICTkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:40:04 -0400
X-Forefront-Antispam-Report: CIP:157.56.232.165;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0810HT004.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI1432Izz1202hzz8275bh8275dhz2fh2a8h668h839hd25he5bhf0ah107ah1155h)
Message-ID: <5045077F.80700@ozmodevices.com>
Date: Mon, 3 Sep 2012 20:39:43 +0100
From: Rupesh Gujare <rgujare@ozmodevices.com>
Organization: Ozmo Devices
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: <greg@kroah.com>, <linux-kernel@vger.kernel.org>, <ckelly@ozmodevices.com>
Subject: Re: [PATCH] staging/ozwpan: Fix zero address check in oz_set_active_pd
References: <20120903191721.GX16230@one.firstfloor.org>
In-Reply-To: <20120903191721.GX16230@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.5.61.149]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/12 20:17, Andi Kleen wrote:
> gcc 4.8 warns about the incorrect memcmp size. I think it's supposed to
> be an ethernet address, so should be always 6 bytes.
>
> The code was wrong, would either compare 4 or 8 bytes (32bit vs 64bit)
>
> /backup/lsrc/git/linux-lto-2.6/drivers/staging/ozwpan/ozcdev.c: In function 'oz_set_active_pd':
> /backup/lsrc/git/linux-lto-2.6/drivers/staging/ozwpan/ozcdev.c:216:43: warning: argument to 'sizeof' in 'memcmp' call is the same expression as the destination; did you mean to provide an explicit length? [-Wsizeof-pointer-memaccess]
>     if (!memcmp(addr, "\0\0\0\0\0\0", sizeof(addr))) {
>                                             ^
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
> index d983219..63c1b67 100644
> --- a/drivers/staging/ozwpan/ozcdev.c
> +++ b/drivers/staging/ozwpan/ozcdev.c
> @@ -213,7 +213,7 @@ static int oz_set_active_pd(u8 *addr)
>   		if (old_pd)
>   			oz_pd_put(old_pd);
>   	} else {
> -		if (!memcmp(addr, "\0\0\0\0\0\0", sizeof(addr))) {
> +		if (!memcmp(addr, "\0\0\0\0\0\0", ETH_ALEN)) {
>   			spin_lock_bh(&g_cdev.lock);
>   			pd = g_cdev.active_pd;
>   			g_cdev.active_pd = 0;
>

Its already fixed by this patch :-

http://driverdev.linuxdriverproject.org/pipermail/devel/2012-August/029734.html

-- 
Regards,
Rupesh Gujare


