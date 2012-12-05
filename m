Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2LEJfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 04:35:25 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47176 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2LEJfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 04:35:22 -0500
Message-ID: <50BF1554.50303@suse.cz>
Date: Wed, 05 Dec 2012 10:35:16 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Ilya Zykov <ilya@ilyx.ru>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH -next 2/2] tty: Correct tty buffer flush.
References: <50BF0A56.9050209@ilyx.ru>
In-Reply-To: <50BF0A56.9050209@ilyx.ru>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 09:48 AM, Ilya Zykov wrote:
> tty: Correct tty buffer flush.

NAK just because of the insufficient commit log. That line does not
belong here. Instead, please add here proper description as you have
already done before. IOW what is in 0/2 should be here so that we know
the reasons. 0/2 text is not stored in git. This one is.

> Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
> ---
>  drivers/tty/tty_buffer.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
> index 7602df8..8a3333d 100644
> --- a/drivers/tty/tty_buffer.c
> +++ b/drivers/tty/tty_buffer.c
> @@ -119,11 +119,14 @@ static void __tty_buffer_flush(struct tty_port *port)
>  	struct tty_bufhead *buf = &port->buf;
>  	struct tty_buffer *thead;
>  
> -	while ((thead = buf->head) != NULL) {
> -		buf->head = thead->next;
> -		tty_buffer_free(port, thead);
> +	if (unlikely(buf->head == NULL))
> +		return;
> +	while ((thead = buf->head->next) != NULL) {
> +		tty_buffer_free(port, buf->head);
> +		buf->head = thead;
>  	}
> -	buf->tail = NULL;
> +	WARN_ON(buf->head != buf->tail);
> +	buf->head->read = buf->head->commit;
>  }
>  
>  /**
> 

thanks,
-- 
js
suse labs
