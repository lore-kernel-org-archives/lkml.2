Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab2CAUbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:31:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44749 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab2CAUbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:31:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.14.200.129 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F4FDC8F.2010300@suse.cz>
Date: Thu, 01 Mar 2012 21:31:11 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 2/6] vt: push down the tty lock so we can see what is
 left to tackle
References: <20120301194831.11322.38295.stgit@bob.linux.org.uk> <20120301195005.11322.78572.stgit@bob.linux.org.uk>
In-Reply-To: <20120301195005.11322.78572.stgit@bob.linux.org.uk>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 08:50 PM, Alan Cox wrote:
> --- a/drivers/tty/vt/vt_ioctl.c
> +++ b/drivers/tty/vt/vt_ioctl.c
> @@ -281,7 +281,6 @@ int vt_ioctl(struct tty_struct *tty,
>  
>  	console = vc->vc_num;
>  
> -	tty_lock();

Note that this breaks bisection. Further in vt_ioctl, there is a call to
vt_event_wait_ioctl which calls vt_event_wait and that calls
wait_event_interruptible_tty which unlocks BTM.

You change wait_event_interruptible_tty to wait_event_interruptible even
in 4/6.

The VT_WAITEVENT case should have tty_lock until 4/6 (and not longer).

thanks,
-- 
js
suse labs
