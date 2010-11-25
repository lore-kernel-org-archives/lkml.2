Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0KYXNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 18:13:42 -0500
Received: from build.ihdev.net ([178.63.197.118]:50910 "EHLO build.ossfans.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab0KYXNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 18:13:41 -0500
Date: Thu, 25 Nov 2010 18:13:34 -0500
From: Sergey Lapin <slapin@ossfans.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>,
        Andrew Hendry <andrew.hendry@gmail.com>, linux-x25@vger.kernel.org
Subject: Re: [PATCH 2/2] NET: wan/x25, fix ldisc->open retval
Message-ID: <20101125231334.GB13807@build.ihdev.net>
References: <4CED9498.9080900@suse.cz>
 <1290641275-21726-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290641275-21726-2-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 12:27:55AM +0100, Jiri Slaby wrote:
> We should never return positive values from ldisc->open, tty layer
> doesn't (and never did) expect that.
> 
> If we do that, weird things like warnings in tty_ldisc_close happen.
> 
> Not sure if dev->base_addr is used somehow now.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Andrew Hendry <andrew.hendry@gmail.com>
> Cc: linux-x25@vger.kernel.org
Tested-by: Sergey Lapin <slapin@ossfans.org>
> ---
>  drivers/net/wan/x25_asy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
> index d81ad83..66cda25 100644
> --- a/drivers/net/wan/x25_asy.c
> +++ b/drivers/net/wan/x25_asy.c
> @@ -582,7 +582,7 @@ static int x25_asy_open_tty(struct tty_struct *tty)
>  	if (err)
>  		return err;
>  	/* Done.  We have linked the TTY line to a channel. */
> -	return sl->dev->base_addr;
> +	return 0;
>  }
>  
>  
> -- 
> 1.7.3.1
> 
