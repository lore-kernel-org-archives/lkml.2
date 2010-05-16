Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0EPDQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 23:16:46 -0400
Received: from in.cluded.net ([195.159.98.120]:40156 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab0EPDQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 23:16:45 -0400
Message-ID: <4BEF6293.2000900@uw.no>
Date: Sun, 16 May 2010 03:12:19 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 08/10] tty: untangle locking of wait_until_sent
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <1273957196-13768-9-git-send-email-arnd@arndb.de>
In-Reply-To: <1273957196-13768-9-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
> index 5bd382e..3c0231a 100644
> --- a/drivers/char/amiserial.c
> +++ b/drivers/char/amiserial.c
> @@ -1527,6 +1527,7 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
>  {
>  	struct async_struct * info = tty->driver_data;
>  	unsigned long orig_jiffies, char_time;
> +	int tty_was_locked = tty_locked();
>  	int lsr;
>  
>  	if (serial_paranoia_check(info, tty->name, "rs_wait_until_sent"))
> @@ -1578,7 +1584,8 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
>  			break;
>  	}
>  	__set_current_state(TASK_RUNNING);
> -	tty_unlock();
> +	if (!tty_was_locked())

tty_was_locked is not a function.


Daniel K.
