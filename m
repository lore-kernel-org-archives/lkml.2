Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2EEHjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 03:39:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63425 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2EEHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 03:39:42 -0400
Message-ID: <4FA4D93A.6090103@suse.cz>
Date: Sat, 05 May 2012 09:39:38 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120428 Thunderbird/14.0a2
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Guy Martin <gmsof@tuxicoman.be>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert 5dd5bc40f3b6e0ccdaad948dbadc94ad0906cb25
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com> <Pine.LNX.4.64.1205042259000.18896@file.rdu.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1205042259000.18896@file.rdu.redhat.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 05:04 AM, Mikulas Patocka wrote:
> Hi
> 
> This patch reverts commit 5dd5bc40f3b6e0ccdaad948dbadc94ad0906cb25.
> 
> The commit 5dd5bc40f3b6e0ccdaad948dbadc94ad0906cb25 causes system lockup 
> when pdc is used as a boot console.
> 
> The kernel boots, but it locks up when transferring control to userspace 
> --- the message "INIT: version 2.86 booting" is not printed and the 
> computer halts. With the patch reverted, the system starts normally on 
> pdc.
...
> --- a/arch/parisc/kernel/pdc_cons.c
> +++ b/arch/parisc/kernel/pdc_cons.c
...
> @@ -104,10 +103,8 @@ static int pdc_console_tty_open(struct tty_struct *tty, struct file *filp)
>  
>  static void pdc_console_tty_close(struct tty_struct *tty, struct file *filp)
>  {
> -	if (!tty->count) {
> +	if (!tty->count)

Heh, I cannot find a bug in the patch proper. However this test is and
always was bogus. Does changing "!tty->count" to "tty->count == 1" help?

>  		del_timer_sync(&pdc_console_timer);
> -		tty_port_tty_set(&tty_port, NULL);
> -	}
>  }
>  
>  static int pdc_console_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)

regards,
-- 
js
suse labs


