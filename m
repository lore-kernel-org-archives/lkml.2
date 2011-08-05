Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1HEBtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 21:49:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:41243 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1HEBtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 21:49:17 -0400
Date: Thu, 4 Aug 2011 21:48:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the moduleh tree with the
 staging.current tree
Message-ID: <20110805014832.GD14262@windriver.com>
References: <20110803135150.249e34087e78caa2797d2b60@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110803135150.249e34087e78caa2797d2b60@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: manual merge of the moduleh tree with the staging.current tree] On 03/08/2011 (Wed 13:51) Stephen Rothwell wrote:

> Hi Paul,
> 
> Today's linux-next merge of the moduleh tree got a conflict in
> drivers/staging/dt3155v4l/dt3155v4l.c between commit dac95cb8cf40
> ("drivers/staging/dt3155v4l/dt3155v4l.c needs slab.h") from the
> staging.current tree and commit 9e1049c45c01 ("staging: Add module.h to
> drivers/staging users") from the moduleh tree.
> 
> Also note that commit 5c751107250f ("staging: fix implicit use of slab.h
> in dt3155v4l/dt3155v4l.c") from the moduleh tree is a duplicate of the
> above staging.current tree commit (with the include in a slightly
> different spot.

I can easily relocate the include so #1 goes away, and drop the #2
if Greg now has it.  But since I would have to rebase to do both,
I'll hold off until it is 100% clear that Linus has decided to
defer this for 3.2-rc1 instead.  (He did mention two weeks ago that he
might take an extra couple days to catch up on merging stuff even after
the two week window for requesting it to be merged in had closed.)

Thanks,
Paul.

> 
> I fixed it up (see below) anc can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/staging/dt3155v4l/dt3155v4l.c
> index 05aa41c,024390b..0000000
> --- a/drivers/staging/dt3155v4l/dt3155v4l.c
> +++ b/drivers/staging/dt3155v4l/dt3155v4l.c
> @@@ -21,8 -21,9 +21,9 @@@
>   #include <linux/version.h>
>   #include <linux/stringify.h>
>   #include <linux/delay.h>
>  -#include <linux/slab.h>
>   #include <linux/kthread.h>
>  +#include <linux/slab.h>
> + #include <linux/module.h>
>   #include <media/v4l2-dev.h>
>   #include <media/v4l2-ioctl.h>
>   #include <media/videobuf2-dma-contig.h>
