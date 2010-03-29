Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0C2Ttl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:49:41 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:30908 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0C2Ttk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:49:40 -0400
Date: Mon, 29 Mar 2010 12:47:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] treewide: Add and use ADD_MOD macro
Message-Id: <20100329124708.898b617c.randy.dunlap@oracle.com>
In-Reply-To: <1269813447.1500.69.camel@Joe-Laptop.home>
References: <1269813447.1500.69.camel@Joe-Laptop.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BB10404.0058:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Mar 2010 14:57:27 -0700 Joe Perches wrote:

> Add a macro for the somewhat common use of
> 
> 	(something + value) % value
> 
> drivers/net/sundance.c includes a change from
> a for(;test;add) loop to while (test) {... add};
> because the test uses ADD_MOD
> 
> Compile tested only
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/kernel.h                  |    1 +
>  drivers/ata/libata-eh.c                 |    2 +-
>  drivers/media/video/ov511.c             |    2 +-
>  drivers/media/video/usbvideo/usbvideo.c |    2 +-
>  drivers/net/dl2k.c                      |    8 ++++----
>  drivers/net/sundance.c                  |    4 ++--
>  drivers/pci/dmar.c                      |    6 +++---
>  drivers/scsi/3w-9xxx.c                  |    2 +-
>  drivers/staging/wavelan/wavelan_cs.c    |   10 +++++-----
>  drivers/usb/misc/sisusbvga/sisusb_con.c |    4 ++--
>  drivers/video/console/vgacon.c          |    4 ++--
>  sound/oss/vwsnd.c                       |    6 +++---
>  12 files changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 7f07074..c96b1ac 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -63,6 +63,7 @@ extern const char linux_proc_banner[];
>  	(((x) + ((__divisor) / 2)) / (__divisor));	\
>  }							\
>  )
> +#define ADD_MOD(x, y) (((x) + (y)) % (y))
>  
>  #define _RET_IP_		(unsigned long)__builtin_return_address(0)
>  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })


It would be better not to evaluate y more than one time.

Also it's not safe for 64-bit 'y' on i386, right?
Looks like it would cause missing reference to __imoddi3 or whatever it is called.

so it can easily be misused IMO.

---
~Randy
