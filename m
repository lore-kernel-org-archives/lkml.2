Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0JQPe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 11:34:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38571 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab0JQPe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 11:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=bIJw7k/fmOF/1GfT7DMSspeF1tyNh6XIrpspHU5Weubz1soFVRO/lf52A2aOcWkujn
         pg0/3YmJ72fHD9/uX7/C1EoDnsFhI4kqmA3zQrqFKs5zXFErx4+L8XRYMA8wczeBFuJR
         KFyNpqhA51S3jfjtMr33f/AuvPUY/0CzWi/Gw=
Message-ID: <4CBB177C.9050007@suse.cz>
Date: Sun, 17 Oct 2010 17:34:20 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] char: synclink: fix information leak to userland
References: <1287326493-8134-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1287326493-8134-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2010 04:41 PM, Vasiliy Kulikov wrote:
> Structure new_line is copied to userland with some padding fields unitialized.
> It leads to leaking of stack memory.

I think your tool has a bug. I must admit I fail to see the padding
which would cause leaks. Could you elaborate?

> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  drivers/char/synclink.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
> index 3a6824f..abd0867 100644
> --- a/drivers/char/synclink.c
> +++ b/drivers/char/synclink.c
> @@ -7846,6 +7846,8 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  	if (cmd != SIOCWANDEV)
>  		return hdlc_ioctl(dev, ifr, cmd);
>  
> +	memset(&new_line, 0, size);
> +
>  	switch(ifr->ifr_settings.type) {
>  	case IF_GET_IFACE: /* return current sync_serial_settings */
>  


-- 
js
suse labs
