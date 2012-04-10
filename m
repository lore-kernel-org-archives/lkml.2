Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2DJIhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:37:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36109 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2DJIhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:37:01 -0400
Message-ID: <4F83F125.9080206@suse.cz>
Date: Tue, 10 Apr 2012 10:36:53 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Karsten Keil <isdn@linux-pingi.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/1] ISDN: remove uses of isdn_tty_revision
References: <20120410130637.d9aff141830a3eb71ff21440@canb.auug.org.au> <1334046929-31282-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1334046929-31282-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 10:35 AM, Jiri Slaby wrote:
> Commit "ISDN: i4l, remove cvs crap" removed definition of
> isdn_tty_revision, but there is still a user. So this causes linking
> errors. This was hidden from my radar because the variable was not
> declared in any header. Instead isdn_common.c declares it locally.
> 
> So remove this variable also from isdn_common.c, because there is
> really no way to find out the version. Git commit or tag is...
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Karsten Keil <isdn@linux-pingi.de>

Oh, and

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks!

> ---
>  drivers/isdn/i4l/isdn_common.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
> index 2ffa0b73..8c610fa 100644
> --- a/drivers/isdn/i4l/isdn_common.c
> +++ b/drivers/isdn/i4l/isdn_common.c
> @@ -46,7 +46,6 @@ static DEFINE_MUTEX(isdn_mutex);
>  static char *isdn_revision = "$Revision: 1.1.2.3 $";
>  
>  extern char *isdn_net_revision;
> -extern char *isdn_tty_revision;
>  #ifdef CONFIG_ISDN_PPP
>  extern char *isdn_ppp_revision;
>  #else
> @@ -2351,8 +2350,6 @@ static int __init isdn_init(void)
>  
>  	strcpy(tmprev, isdn_revision);
>  	printk(KERN_NOTICE "ISDN subsystem Rev: %s/", isdn_getrev(tmprev));
> -	strcpy(tmprev, isdn_tty_revision);
> -	printk("%s/", isdn_getrev(tmprev));
>  	strcpy(tmprev, isdn_net_revision);
>  	printk("%s/", isdn_getrev(tmprev));
>  	strcpy(tmprev, isdn_ppp_revision);
> 



-- 
js
suse labs

