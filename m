Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab0FQUlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:41:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51898 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab0FQUlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:41:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Remove Hayes ESP ioctls
Date: Thu, 17 Jun 2010 22:41:05 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc1-00090-g358f4b6; KDE/4.4.2; x86_64; ; )
Cc: Jeff Dike <jdike@addtoit.com>, Alan Cox <alan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20100617160045.GA13743@c-98-229-117-200.hsd1.ma.comcast.net> <20100617200938.GB25977@kroah.com> <20100617201417.GA2873@kroah.com>
In-Reply-To: <20100617201417.GA2873@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006172241.05878.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19AQM3IObfdTZdwvV9wmyvoJ19Y0PozI//d0EE
 vZw8xr0/MSMsSKu4v34WCuSgsvJRMwxpIckFa5wNXAP4megErB
 PyC3WWX0HwZXiUCd7huWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 June 2010 22:14:17 Greg KH wrote:
> --- a/include/asm-generic/ioctls.h
> +++ b/include/asm-generic/ioctls.h
> @@ -87,12 +87,10 @@
>  #define TIOCGICOUNT    0x545D  /* read serial port inline interrupt counts */
>  
>  /*
> - * some architectures define FIOQSIZE as 0x545E, which is used for
> - * TIOCGHAYESESP on others
> + * Some arches already define FIOQSIZE due to a historical
> + * conflict with a Hayes modem-specific ioctl value.
>   */
>  #ifndef FIOQSIZE
> -# define TIOCGHAYESESP 0x545E  /* Get Hayes ESP configuration */
> -# define TIOCSHAYESESP 0x545F  /* Set Hayes ESP configuration */
>  # define FIOQSIZE      0x5460
>  #endif

Yes, that looks right. I had introduced the #ifdef originally, but
did not look closely enough at the patch now.

	Arnd
