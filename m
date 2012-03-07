Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2CGM0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:26:44 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46865 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab2CGM0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:26:42 -0500
Message-ID: <4F5753FE.4080909@suse.cz>
Date: Wed, 07 Mar 2012 13:26:38 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120229 Thunderbird/11.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [patch] tty: moxa: fix bit test in moxa_start()
References: <20120307100500.GD25452@elgon.mountain>
In-Reply-To: <20120307100500.GD25452@elgon.mountain>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 11:05 AM, Dan Carpenter wrote:
> This is supposed to be doing a shift before the comparison instead of
> just doing a bitwise AND directly.  The current code means the start()
> just returns without doing anything.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

ACK.

It was introduced by this commit which forgot to change that location:
commit a808ac0c4a2c5d81ba38a2a76d4ddc1de40d1539
Author: Alan Cox <alan@linux.intel.com>
Date:   Mon Nov 30 13:18:02 2009 +0000

    tty: moxa: Locking clean up

> diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
> index d15a071..0174d2d 100644
> --- a/drivers/tty/moxa.c
> +++ b/drivers/tty/moxa.c
> @@ -1331,7 +1331,7 @@ static void moxa_start(struct tty_struct *tty)
>  	if (ch == NULL)
>  		return;
>  
> -	if (!(ch->statusflags & TXSTOPPED))
> +	if (!test_bit(TXSTOPPED, &ch->statusflags))
>  		return;
>  
>  	MoxaPortTxEnable(ch);

thanks,
-- 
js
suse labs
