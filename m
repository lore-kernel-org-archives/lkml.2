Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0I2VVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:21:54 -0400
Received: from tuxonice.net ([74.207.252.127]:44856 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916Ab0I2VVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:21:52 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CA3ADED.6090908@tuxonice.net>
Date: Thu, 30 Sep 2010 07:21:49 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM / Hibernate: Modify signature used to mark swap
References: <201009292313.23601.rjw@sisk.pl>
In-Reply-To: <201009292313.23601.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 30/09/10 07:13, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki<rjw@sisk.pl>
> Subject: PM / Hibernate: Modify signature used to mark swap
>
> Since we are adding compression to the kernel's hibernate code,
> change signature used by it to mark swap spaces, so that earlier
> kernels don't attempt to restore compressed images they cannot
> handle.
>
> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> ---
>   kernel/power/swap.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/kernel/power/swap.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/swap.c
> +++ linux-2.6/kernel/power/swap.c
> @@ -29,7 +29,7 @@
>
>   #include "power.h"
>
> -#define SWSUSP_SIG	"S1SUSPEND"
> +#define HIBERNATE_SIG	"LINHIB0001"
>
>   /*
>    *	The swap map is a data structure used for keeping track of each page
> @@ -195,7 +195,7 @@ static int mark_swapfiles(struct swap_ma
>   	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
>   	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
>   		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);

if no compression

> -		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);

else

> +		memcpy(swsusp_header->sig, HIBERNATE_SIG, 10);

??

>   		swsusp_header->image = handle->first_sector;
>   		swsusp_header->flags = flags;
>   		error = hib_bio_write_page(swsusp_resume_block,
> @@ -916,7 +916,7 @@ int swsusp_check(void)
>   		if (error)
>   			goto put;
>
> -		if (!memcmp(SWSUSP_SIG, swsusp_header->sig, 10)) {
> +		if (!memcmp(HIBERNATE_SIG, swsusp_header->sig, 10)) {

Reset the signature in either case?

>   			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
>   			/* Reset swap signature now */
>   			error = hib_bio_write_page(swsusp_resume_block,
>

Regards,

Nigel
