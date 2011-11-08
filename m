Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1KHI2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:28:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59402 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1KHI2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:28:00 -0500
Message-ID: <4EB8E80A.1050805@suse.cz>
Date: Tue, 08 Nov 2011 09:27:54 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ldisc: remove unnecessary negative return check for
 wait_event_timeout
References: <20111108054459.GA23162@darkstar.nay.redhat.com>
In-Reply-To: <20111108054459.GA23162@darkstar.nay.redhat.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 06:44 AM, Dave Young wrote:
> wait_event_timeout always return value >= 0
> remove the unnecessary ret < 0 check
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Acked-by: Jiri Slaby <jslaby@suse.cz>

This is a hangover from times when there was _interruptible.

> ---
>  drivers/tty/tty_ldisc.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> --- linux-2.6.orig/drivers/tty/tty_ldisc.c	2011-11-01 13:06:20.000000000 +0800
> +++ linux-2.6/drivers/tty/tty_ldisc.c	2011-11-08 13:31:30.596308060 +0800
> @@ -556,8 +556,6 @@ static int tty_ldisc_wait_idle(struct tt
>  	int ret;
>  	ret = wait_event_timeout(tty_ldisc_idle,
>  			atomic_read(&tty->ldisc->users) == 1, 5 * HZ);
> -	if (ret < 0)
> -		return ret;
>  	return ret > 0 ? 0 : -EBUSY;
>  }
>  
-- 
js
suse labs
