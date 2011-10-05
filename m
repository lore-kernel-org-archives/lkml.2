Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935317Ab1JET7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:59:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:52199 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934378Ab1JET7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:59:52 -0400
Date: Wed, 5 Oct 2011 15:59:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Todd Poynor <toddpoynor@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the moduleh tree with the mfd tree
Message-ID: <20111005195942.GV14123@windriver.com>
References: <20111005183641.922f5e5da976b972f25a6d90@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111005183641.922f5e5da976b972f25a6d90@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: manual merge of the moduleh tree with the mfd tree] On 05/10/2011 (Wed 18:36) Stephen Rothwell wrote:

> Hi Paul,
> 
> Today's linux-next merge of the moduleh tree got a conflict in
> drivers/mfd/twl6030-irq.c between commit 2b8af0825999 ("mfd: Fix twl6030
> lockdep recursion warning on setting wake IRQs") from the mfd tree and
> commit c86747746435 ("mfd: Add export.h for EXPORT_SYMBOL/THIS_MODULE as
> required") from the moduleh tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.


I've relocated this include to avoid the conflict, and also dropped the
two post-merge patches that Greg now has.

Thanks,
Paul.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/mfd/twl6030-irq.c
> index deec3ec,b57383b..0000000
> --- a/drivers/mfd/twl6030-irq.c
> +++ b/drivers/mfd/twl6030-irq.c
> @@@ -37,7 -37,7 +37,8 @@@
>   #include <linux/kthread.h>
>   #include <linux/i2c/twl.h>
>   #include <linux/platform_device.h>
>  +#include <linux/suspend.h>
> + #include <linux/export.h>
>   
>   #include "twl-core.h"
>   


