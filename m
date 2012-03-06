Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab2CFOJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:09:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33662 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab2CFOJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:09:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.213.104.143 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F561AA3.6050600@suse.cz>
Date: Tue, 06 Mar 2012 15:09:39 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [patch v2] tty: cyclades: TIOCSERGETLSR should should store to
 a uint
References: <20120305180711.GB26880@elgon.mountain>
In-Reply-To: <20120305180711.GB26880@elgon.mountain>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 07:07 PM, Dan Carpenter wrote:
> TIOCSERGETLSR should be saved in a uint so the cast here to unsigned
> long is a bug.
> 
> Reported-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

ACK. Thanks.

> ---
> v2: completely different from v1.
> 
> diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
> index c9bf779..5575fee 100644
> --- a/drivers/tty/cyclades.c
> +++ b/drivers/tty/cyclades.c
> @@ -2413,7 +2413,7 @@ static int get_lsr_info(struct cyclades_port *info, unsigned int __user *value)
>  		/* Not supported yet */
>  		return -EINVAL;
>  	}
> -	return put_user(result, (unsigned long __user *)value);
> +	return put_user(result, value);
>  }
>  
>  static int cy_tiocmget(struct tty_struct *tty)
-- 
js
suse labs
