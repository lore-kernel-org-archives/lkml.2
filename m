Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1BKIQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 03:16:20 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:46718 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1BKIQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 03:16:18 -0500
Date: Fri, 11 Feb 2011 09:16:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: build failure after merge of the i2c tree (arm tree
  interaction)
Message-ID: <20110211091605.367d75aa@endymion.delvare>
In-Reply-To: <20110211114514.67f377b9.sfr@canb.auug.org.au>
References: <20110211114514.67f377b9.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011 11:45:14 +1100, Stephen Rothwell wrote:
> Hi Jean,
> 
> After merging the i2c tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/video/cyber2000fb.c:51:26: error: linux/i2c-id.h: No such file or directory
> 
> Caused by commit 06bc0fe05c62297e1db2979d591770459439866e ("i2c: Get rid
> of <linux/i2c-id.h>") interacting with commit
> 8749b1ad69f91be1f5735563c7f235f802c7ea7d ("VIDEO: cyberpro: add I2C
> support") from the arm tree.
> 
> I applied the following fix up patch for today.  Russell, this could be
> applied in the arm tree as there is nothing relevant in that header file
> even in Linus' tree.

Yes, the patch is correct and applying it to the arm tree is the right
thing to do.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 11 Feb 2011 11:41:35 +1100
> Subject: [PATCH] VIDEO: cyberpro: remove obsolate include
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/video/cyber2000fb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/cyber2000fb.c b/drivers/video/cyber2000fb.c
> index 44db875..8503807 100644
> --- a/drivers/video/cyber2000fb.c
> +++ b/drivers/video/cyber2000fb.c
> @@ -48,7 +48,6 @@
>  #include <linux/init.h>
>  #include <linux/io.h>
>  #include <linux/i2c.h>
> -#include <linux/i2c-id.h>
>  #include <linux/i2c-algo-bit.h>
>  
>  #include <asm/pgtable.h>

Thanks,
-- 
Jean Delvare
