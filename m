Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2HVMT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:19:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47817 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab2HVMTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:19:55 -0400
Message-ID: <5034CE65.7040607@suse.cz>
Date: Wed, 22 Aug 2012 14:19:49 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120731 Thunderbird/15.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: shijie8@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: move the async flags from the serial code into the
 tty includes
References: <20120821133455.9090.24759.stgit@localhost.localdomain>
In-Reply-To: <20120821133455.9090.24759.stgit@localhost.localdomain>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 03:35 PM, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> These are used with the tty_port flags which are tty generic so move the
> flags into a more sensible place. This then makes it possible to add
> helpers such as those suggested by Huang Shijie.

Yes, the idea looks good to me. I was actually thinking of the same.

But there are two issues with this patch (see below).

> --- a/include/linux/serial.h
> +++ b/include/linux/serial.h
> @@ -15,6 +15,8 @@
>  #ifdef __KERNEL__
>  #include <asm/page.h>
>  
> +#include <linux/tty_flags.h>
> +

There are no minus lines in serial.h -- we have two copies of the flags
now? That looks insane.

The flags are a user API. You concealed them by the #include inside the
__KERNEL__ section (if I consider we do not have the flags defined twice).

And if we move the include outside of the __KERNEL__ section, we shall
update Kconfig, so that the new header is installed.

>  /*
>   * Counters of the input lines (CTS, DSR, RI, CD) interrupts
>   */
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 69a787f..dbebd1e 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -43,6 +43,7 @@
>  #include <linux/tty_driver.h>
>  #include <linux/tty_ldisc.h>
>  #include <linux/mutex.h>
> +#include <linux/tty_flags.h>

thanks,
-- 
js
suse labs
