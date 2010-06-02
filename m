Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab0FBKMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:12:49 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42883 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0FBKMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:12:47 -0400
Message-ID: <4C062E69.8050406@ru.mvista.com>
Date: Wed, 02 Jun 2010 14:11:53 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/6] USB-BKL: Remove BKL use in uhci-debug
References: <1275426285-9088-1-git-send-email-arnd@arndb.de> <1275426285-9088-5-git-send-email-arnd@arndb.de>
In-Reply-To: <1275426285-9088-5-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Arnd Bergmann wrote:

> From: Andi Kleen <ak@linux.intel.com>

> BKL was not really needed, just came from earlier push downs.

> The only part that's a bit dodgy is the lseek function. Would
> need another lock or atomic access to fpos on 32bit?
> Better to have a libfs lseek

> Signed-off-by: Andi Kleen <ak@linux.intel.com>

[...]

> diff --git a/drivers/usb/host/uhci-debug.c b/drivers/usb/host/uhci-debug.c
> index 98cf0b2..b0cf4f8 100644
> --- a/drivers/usb/host/uhci-debug.c
> +++ b/drivers/usb/host/uhci-debug.c

[...]

> @@ -539,11 +534,11 @@ static loff_t uhci_debug_lseek(struct file *file, loff_t off, int whence)
>  		new = file->f_pos + off;
>  		break;
>  	}
> +
> +	/* XXX: Can size shrink? */
>  	if (new < 0 || new > up->size) {
> -		unlock_kernel();
>  		return -EINVAL;
>  	}

    Should have dropped {}...

> -	unlock_kernel();
>  	return (file->f_pos = new);
>  }

WBR, Sergei
