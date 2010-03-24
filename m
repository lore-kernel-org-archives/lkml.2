Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0CXCZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:25:01 -0400
Received: from senator.holtmann.net ([87.106.208.187]:52714 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0CXCZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:25:00 -0400
Subject: Re: [PATCH 1/7] serial: TTY: new ldisc for TI BT/FM/GPS chips
From: Marcel Holtmann <marcel@holtmann.org>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in
In-Reply-To: <1269376875-25940-2-git-send-email-pavan_savoy@ti.com>
References: <1269376875-25940-1-git-send-email-pavan_savoy@ti.com>
	 <1269376875-25940-2-git-send-email-pavan_savoy@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 19:24:50 -0700
Message-ID: <1269397490.11714.104.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

> A new N_TI_WL line discipline added for TI BT/FM/GPS
> combo chips which make use of same TTY to communicate
> with chip. This is to be made use of individual protocol
> BT/FM/GPS drivers.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  include/linux/tty.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 4409967..8288ee1 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -23,7 +23,7 @@
>   */
>  #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
>  #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
> -#define NR_LDISCS		20
> +#define NR_LDISCS		21
>  
>  /* line disciplines */
>  #define N_TTY		0
> @@ -48,6 +48,7 @@
>  #define N_PPS		18	/* Pulse per Second */
>  
>  #define N_V253		19	/* Codec control over voice modem */
> +#define N_TI_WL	20	/* for TI's WL connectivity chips */
>  
>  /*
>   * This character is the same as _POSIX_VDISABLE: it cannot be used as

why is this even targeting staging. I prefer if we have proper review
cycles and get this reviewed this way. This looks like more a shortcut
to get things into the kernel than actually spending the effort to clean
things up.

If this would be just a driver, I wouldn't care, but it tries to assign
official numbers for a line discipline and clearly collides with other
peoples work that are going the proper upstream review cycles.

Greg, I would like to see the rule that if it touches files outside of
drivers/staging/ then it is not eligible for staging.

Regards

Marcel


