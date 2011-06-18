Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab1FRTBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 15:01:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab1FRTBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 15:01:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 2/10 v2] Generic Watchdog Timer Driver
Date: Sat, 18 Jun 2011 21:01:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110618172043.GC3441@infomag.iguana.be>
In-Reply-To: <20110618172043.GC3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182101.15523.arnd@arndb.de>
X-Provags-ID: V02:K0:ReDQmZ6Nft+bhc2sWa8ho9RDEugMYKSquzhihRkXC3Y
 8owTEJU/j9G0dq10+kGjEUEWkoIfz3DTZ0DRChfRRPQ8BFfVk/
 saKmJrm9BoL7WWu9b7a49YMYgLr/TjWa5pA41KKlm0CML4sZyX
 zdWfuFwIxxnKbSfj5W9cghOoWS2BTpjqi8+nRs+QGYm0naikOD
 u0tQHD6GGkCMdeNY0PABA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 19:20:43 Wim Van Sebroeck wrote:

> +/*
>   *	watchdog_open: open the /dev/watchdog device.
>   *	@inode: inode of device
>   *	@file: file handle to device
> @@ -202,6 +237,7 @@
>  	.owner		= THIS_MODULE,
>  	.llseek		= no_llseek,
>  	.write		= watchdog_write,
> +	.unlocked_ioctl	= watchdog_ioctl,
>  	.open		= watchdog_open,
>  	.release	= watchdog_release,
>  };

All the ioctl commands are compatible with their 32 bit counterparts, so
you can just set ".compat_ioctl = watchdog_ioctl" here to slightly speed
up the ioctl operation for compat tasks.

Looks good otherwise.

	Arnd
