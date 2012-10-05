Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2JEIJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:09:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50835 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab2JEIJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:09:09 -0400
Message-ID: <506E95A0.2020903@suse.cz>
Date: Fri, 05 Oct 2012 10:09:04 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: samuel@sortiz.org, davem@davemloft.net, gregkh@linuxfoundation.org,
        alan@linux.intel.com, levinsasha928@gmail.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net, TTY: initialize tty->driver_data before usage
References: <1349395281-12495-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1349395281-12495-1-git-send-email-sasha.levin@oracle.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 02:01 AM, Sasha Levin wrote:
> Commit 9c650ffc ("TTY: ircomm_tty, add tty install") split _open() to
> _install() and _open(). It also moved the initialization of driver_data
> out of open(), but never added it to install() - causing a NULL ptr
> deref whenever the driver was used.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  net/irda/ircomm/ircomm_tty.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
> index 95a3a7a..496ce2c 100644
> --- a/net/irda/ircomm/ircomm_tty.c
> +++ b/net/irda/ircomm/ircomm_tty.c
> @@ -421,6 +421,8 @@ static int ircomm_tty_install(struct tty_driver *driver, struct tty_struct *tty)
>  		hashbin_insert(ircomm_tty, (irda_queue_t *) self, line, NULL);
>  	}
>  
> +	tty->driver_data = self;
> +
>  	return tty_port_install(&self->port, driver, tty);

Yes, a good catch.

Acked-by: Jiri Slaby <jslaby@suse.cz>

thanks,
-- 
js
suse labs
