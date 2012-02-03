Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2BCUIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:08:45 -0500
Received: from mail1.windriver.com ([147.11.146.13]:63729 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2BCUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:08:43 -0500
X-Greylist: delayed 14488 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Feb 2012 15:08:43 EST
Message-ID: <4F2C0606.7000409@windriver.com>
Date: Fri, 3 Feb 2012 11:06:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Jamie Iles <jamie@jamieiles.com>, Stephen Warren <swarren@nvidia.com>,
        <linux-serial@vger.kernel.org>
Subject: Re: [Patch] tty: fix a build failure on sparc
References: <1328246540-5824-1-git-send-email-xiyou.wangcong@gmail.com>
In-Reply-To: <1328246540-5824-1-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-02-03 12:22 AM, Cong Wang wrote:
> On sparc, there is a build failure:
> 
> drivers/tty/serial/8250/8250.c:48:21: error: suncore.h: No such file or directory
> drivers/tty/serial/8250/8250.c:3275: error: implicit declaration of function 'sunserial_register_minors'
> drivers/tty/serial/8250/8250.c:3305: error: implicit declaration of function 'sunserial_unregister_minors'
> 
> this is due to commit 9bef3d4197379a995fa80f81950bbbf8d32e9e8b
> (serial: group all the 8250 related code together) moved these files
> into 8250/ subdirectory, but forgot to change the reference
> to drivers/tty/serial/suncore.h.

Thanks, I explicitly left sunsu out of the move but missed
that 8250 was sourcing its related header.  I did defconfig
builds, but in going back to check, I see that neither sparc
32/64 defconfig enable 8250 by default, so those builds didn't
help me much at all...  :(

Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>

> 
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> index 9f50c4e..9b7336f 100644
> --- a/drivers/tty/serial/8250/8250.c
> +++ b/drivers/tty/serial/8250/8250.c
> @@ -45,7 +45,7 @@
>  #include "8250.h"
>  
>  #ifdef CONFIG_SPARC
> -#include "suncore.h"
> +#include "../suncore.h"
>  #endif
>  
>  /*
