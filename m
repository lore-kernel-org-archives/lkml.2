Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab2CBTVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:21:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34394 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759123Ab2CBTVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:21:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.213.34.20 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F511DAD.1060108@suse.cz>
Date: Fri, 02 Mar 2012 20:21:17 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] tty: cyclades: clean up a type issue
References: <20120302064908.GA24508@elgon.mountain>
In-Reply-To: <20120302064908.GA24508@elgon.mountain>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 07:49 AM, Dan Carpenter wrote:
> --- a/drivers/tty/cyclades.c
> +++ b/drivers/tty/cyclades.c
...
> @@ -2413,7 +2413,7 @@ static int get_lsr_info(struct cyclades_port *info, unsigned int __user *value)
>  		/* Not supported yet */
>  		return -EINVAL;
>  	}
> -	return put_user(result, (unsigned long __user *)value);
> +	return put_user(result, value);

This was and is wrong BTW. TIOCSERGETLSR should store to uint. Could you
fix that by removing the cast instead, please?

thanks,
-- 
js
suse labs
