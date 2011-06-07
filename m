Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1FGQob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:44:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44133 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab1FGQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:44:30 -0400
X-Sasl-enc: rGrbAP+fu9qoLJb5bZg6GwTRp1mckk+HPVFuYnloredF 1307465069
Date: Tue, 7 Jun 2011 09:44:23 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2 2/2] TTY: ntty, add one more sanity check
Message-ID: <20110607164423.GA32575@kroah.com>
References: <BANLkTik5QP7e=+FWSa1kLVpCjZpWEtF1PQ@mail.gmail.com>
 <1307276177-20957-1-git-send-email-jslaby@suse.cz>
 <1307276177-20957-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307276177-20957-2-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 02:16:17PM +0200, Jiri Slaby wrote:
> With the previous patch, we fixed another bug where read_buf was freed
> while we still was in n_tty_read. We currently check whether read_buf
> is NULL at the start of the function. Add one more check after we wake
> up from waiting for input.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
>  drivers/tty/n_tty.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 95d0a9c..c62c856 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -1785,6 +1785,7 @@ do_it_again:
>  				break;
>  			}
>  			timeout = schedule_timeout(timeout);
> +			BUG_ON(!tty->read_buf);

So, if we ever hit this, what are we going to do with this crash?

I really don't want to add more BUG_ON() calls to the kernel if at all
possible.  Or is it the case that we will crash if this case is true
soon afterward anyway?

thanks,

greg k-h
