Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1AaKoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:44:20 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:39854 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1AaKoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:44:19 -0500
Subject: Re: [PATCH 2/2] s390: Fix possibly wrong size in strncmp (smsglucv)
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: Stefan Weil <weil@mail.berlios.de>
Cc: linux390@de.ibm.com, Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1296336808-2809-2-git-send-email-weil@mail.berlios.de>
References: <1296336808-2809-1-git-send-email-weil@mail.berlios.de>
	 <1296336808-2809-2-git-send-email-weil@mail.berlios.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 11:44:14 +0100
Message-ID: <1296470654.9948.28.camel@braunu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ack - thanks, Stefan.

We have added your smsgiucv patch to our local repository. It will be
part of our next patch collection submitted to Dave Miller for upstream
integration.

Regards, Ursula

On Sat, 2011-01-29 at 22:33 +0100, Stefan Weil wrote:
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
>  		return -EINVAL;
>  	/* Path pending from *MSG. */
>  	return iucv_path_accept(path, &smsg_handler, "SMSGIUCV        ", NULL);


