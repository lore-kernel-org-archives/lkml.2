Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2I0Rdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:33:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50818 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2I0Rdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:33:32 -0400
Message-ID: <50648DE7.2060904@suse.cz>
Date: Thu, 27 Sep 2012 19:33:27 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
        gregkh@linuxfoundation.org, xemul@parallels.com
Subject: Re: [patch 1/2] tty: pty - Move TIOCPKT handling into pty.c
References: <20120927165958.287690622@openvz.org> <20120927170137.722717394@openvz.org>
In-Reply-To: <20120927170137.722717394@openvz.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 06:59 PM, Cyrill Gorcunov wrote:
> --- tty.git.orig/drivers/tty/pty.c
> +++ tty.git/drivers/tty/pty.c
> @@ -174,6 +174,31 @@ static int pty_set_lock(struct tty_struc
>  	return 0;
>  }
>  
> +/* Set the packet mode on a pty */
> +static int pty_set_pktmode(struct tty_struct *tty, int __user *arg)
> +{
> +	unsigned long flags;
> +	int pktmode;
> +
> +	if (tty->driver->subtype != PTY_TYPE_MASTER)
> +		return -ENOTTY;

Hi!

This check is not needed as the ioctls are master-only.

-- 
js
suse labs
