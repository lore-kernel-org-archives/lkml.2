Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1A2VhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 16:37:21 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21728 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1A2VhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 16:37:19 -0500
Date: Sat, 29 Jan 2011 22:38:31 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Stefan Weil <weil@mail.berlios.de>
cc: linux390@de.ibm.com, Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] s390: Fix possibly wrong size in strncmp
 (smsglucv)
In-Reply-To: <1296336808-2809-2-git-send-email-weil@mail.berlios.de>
Message-ID: <alpine.LNX.2.00.1101292237220.19392@swampdragon.chaosbits.net>
References: <1296336808-2809-1-git-send-email-weil@mail.berlios.de> <1296336808-2809-2-git-send-email-weil@mail.berlios.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Jan 2011, Stefan Weil wrote:

> This error was reported by cppcheck:
> drivers/s390/net/smsgiucv.c:63: error: Using sizeof for array given as function argument returns the size of pointer.
> 
> Although there is no runtime problem as long as sizeof(u8 *) == 8,
> this misleading code should get fixed.
> 
> Cc: Ursula Braun <ursula.braun@de.ibm.com>
> Cc: linux390@de.ibm.com
> Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  drivers/s390/net/smsgiucv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/s390/net/smsgiucv.c b/drivers/s390/net/smsgiucv.c
> index 65e1cf1..207b7d7 100644
> --- a/drivers/s390/net/smsgiucv.c
> +++ b/drivers/s390/net/smsgiucv.c
> @@ -60,7 +60,7 @@ static struct iucv_handler smsg_handler = {
>  static int smsg_path_pending(struct iucv_path *path, u8 ipvmid[8],
>  			     u8 ipuser[16])
>  {
> -	if (strncmp(ipvmid, "*MSG    ", sizeof(ipvmid)) != 0)
> +	if (strncmp(ipvmid, "*MSG    ", 8) != 0)

Hmm, shouldn't this really be  ARRAY_SIZE(ipvmid)  ??

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

