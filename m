Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1KWT4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:56:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40127 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1KWT4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:56:01 -0500
Message-ID: <4ECD4FCD.7040602@suse.cz>
Date: Wed, 23 Nov 2011 20:55:57 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111114 Thunderbird/9.0
MIME-Version: 1.0
To: Havard Skinnemoen <hskinnemoen@google.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Subject: Re: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com> <1322074412-10873-1-git-send-email-hskinnemoen@google.com>
In-Reply-To: <1322074412-10873-1-git-send-email-hskinnemoen@google.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 07:53 PM, Havard Skinnemoen wrote:
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
...
> @@ -567,19 +574,10 @@ static void acm_tty_close(struct tty_struct *tty, struct file *filp)
>  
>  	/* Perform the closing process and see if we need to do the hardware
>  	   shutdown */
> -	if (!acm)
> -		return;
> -
> -	mutex_lock(&open_mutex);
>  	if (tty_port_close_start(&acm->port, tty, filp) == 0) {

Note that port->count is protected by port->lock usually. Till now it
used to be protected by open_mutex in your driver. As of now it is not
protected by anything. (Well, BTM is still there to save you, but...)

thanks,
-- 
js
suse labs
