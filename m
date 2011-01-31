Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1AaKhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:37:36 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:54958 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab1AaKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:37:35 -0500
Subject: Re: [PATCH 1/2] s390: Fix wrong size in memcmp (netiucv)
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: Stefan Weil <weil@mail.berlios.de>
Cc: linux390@de.ibm.com, Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1296336808-2809-1-git-send-email-weil@mail.berlios.de>
References: <1296336808-2809-1-git-send-email-weil@mail.berlios.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 11:37:25 +0100
Message-ID: <1296470245.9948.20.camel@braunu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack - thanks, Stefan.

We have added your netiucv patch to our local repository. It will be
part of our next patch collection submitted to Dave Miller for upstream
integration.

Regards, Ursula

On Sat, 2011-01-29 at 22:33 +0100, Stefan Weil wrote:
> This error was reported by cppcheck:
> drivers/s390/net/netiucv.c:568: error: Using sizeof for array given as function argument returns the size of pointer.
> 
> sizeof(ipuser) did not result in 16 (as many programmers would have
> expected) but sizeof(u8 *), so it is 4 or 8, too small here.
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
>  drivers/s390/net/netiucv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
> index 65ebee0..b6a6356 100644
> --- a/drivers/s390/net/netiucv.c
> +++ b/drivers/s390/net/netiucv.c
> @@ -565,7 +565,7 @@ static int netiucv_callback_connreq(struct iucv_path *path,
>  	struct iucv_event ev;
>  	int rc;
> 
> -	if (memcmp(iucvMagic, ipuser, sizeof(ipuser)))
> +	if (memcmp(iucvMagic, ipuser, 16))
>  		/* ipuser must match iucvMagic. */
>  		return -EINVAL;
>  	rc = -EINVAL;


