Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2BWMhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:37:19 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58020 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2BWMhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:37:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.213.10.11 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F4632F8.8090006@suse.cz>
Date: Thu, 23 Feb 2012 13:37:12 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: the briq panel isn't a tty, make it use its own
 locking
References: <20120223123314.1684.89844.stgit@bob.linux.org.uk>
In-Reply-To: <20120223123314.1684.89844.stgit@bob.linux.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 01:34 PM, Alan Cox wrote:
> --- a/drivers/char/briq_panel.c
> +++ b/drivers/char/briq_panel.c
...
> @@ -66,37 +67,28 @@ static void set_led(char state)
>  
>  static int briq_panel_open(struct inode *ino, struct file *filep)
>  {
> -	tty_lock();
> -	/* enforce single access, vfd_is_open is protected by BKL */
> -	if (vfd_is_open) {
> +	/* enforce single open */
> +	if (test_and_set_bit(0, &vfd_is_open)) {
>  		tty_unlock();

This one should be removed too.

>  		return -EBUSY;
>  	}
> -	vfd_is_open = 1;
> -
> -	tty_unlock();
>  	return 0;
>  }

thanks,
-- 
js
suse labs
