Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0G2JN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:13:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34818 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab0G2JN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EONgnP7EB4vZVJ3ZJPUKAoppSlLaXLLfZiNqDK6B7lm9QL0M9/pPTbap7bsqDWAXHd
         NYAGZAhpNlVlus71vE/JGbVI1OwQkHU1oy1RyhJZG2gHVK0FbRDI3Z2Ud6ocauaEMC8Q
         add77m+XBpY6qYl8X8IdMMQV7bDiuRDe7mXBA=
Message-ID: <4C514650.8010305@gmail.com>
Date: Thu, 29 Jul 2010 11:13:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Alan Cox s <alan@linux.intel.com>, stable@kernel.org
Subject: Re: [PATCH 1/1] Char: nozomi, fix tty->count counting
References: <1280394587-31670-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1280394587-31670-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 11:09 AM, Jiri Slaby wrote:
> Currently ntty_install omits to increment tty count and we get the
> following warnings:
> Warning: dev (noz2) tty->count(0) != #fd's(1) in tty_open
> 
> So to fix that, add one tty->count++ there.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@linux.intel.com>

BTW introduced in 266794eb7 (nozomi: Add tty_port usage) which is in
.34. So may be a stable material too...

> ---
>  drivers/char/nozomi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
> index d578449..7f9b858 100644
> --- a/drivers/char/nozomi.c
> +++ b/drivers/char/nozomi.c
> @@ -1611,6 +1611,7 @@ static int ntty_install(struct tty_driver *driver, struct tty_struct *tty)
>  	ret = tty_init_termios(tty);
>  	if (ret == 0) {
>  		tty_driver_kref_get(driver);
> +		tty->count++;
>  		driver->ttys[tty->index] = tty;
>  	}
>  	return ret;

thanks,
-- 
js
