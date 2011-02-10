Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1BJWue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:50:34 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:56531 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757161Ab1BJWud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:50:33 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH 03/10] Add yaffs2 file system: checkpoint streaming
Date: Fri, 11 Feb 2011 11:50:31 +1300
User-Agent: KMail/1.9.10
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        Charles Manning <cdhmanning@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <alpine.LNX.2.00.1102102324530.8012@swampdragon.chaosbits.net> <4D546A5B.5090301@bluewatersys.com>
In-Reply-To: <4D546A5B.5090301@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102111150.31375.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 February 2011 11:44:43 Ryan Mallon wrote:
> On 02/11/2011 11:27 AM, Jesper Juhl wrote:
> > On Wed, 9 Feb 2011, Charles Manning wrote:
> >> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> >> ---
> >>  fs/yaffs2/yaffs_checkptrw.c |  408
> >> +++++++++++++++++++++++++++++++++++++++++++ fs/yaffs2/yaffs_checkptrw.h
> >> |   33 ++++
> >>  2 files changed, 441 insertions(+), 0 deletions(-)
> >>  create mode 100644 fs/yaffs2/yaffs_checkptrw.c
> >>  create mode 100644 fs/yaffs2/yaffs_checkptrw.h
> >>
> >> diff --git a/fs/yaffs2/yaffs_checkptrw.c b/fs/yaffs2/yaffs_checkptrw.c
> >> new file mode 100644
> >> index 0000000..997a618
> >> --- /dev/null
> >> +++ b/fs/yaffs2/yaffs_checkptrw.c
> >> @@ -0,0 +1,408 @@
> >> +/*
> >> + * YAFFS: Yet Another Flash File System. A NAND-flash specific file
> >> system. + *
> >> + * Copyright (C) 2002-2011 Aleph One Ltd.
> >> + *   for Toby Churchill Ltd and Brightstar Engineering
> >> + *
> >> + * Created by Charles Manning <charles@aleph1.co.uk>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + */
> >> +
> >> +#include "yaffs_checkptrw.h"
> >> +#include "yaffs_getblockinfo.h"
> >> +
> >> +static int yaffs2_checkpt_space_ok(struct yaffs_dev *dev)
> >> +{
> >> +	int blocks_avail = dev->n_erased_blocks -
> >> dev->param.n_reserved_blocks; +
> >> +	yaffs_trace(YAFFS_TRACE_CHECKPOINT,
> >> +		"checkpt blocks_avail = %d", blocks_avail);
> >> +
> >> +	return (blocks_avail <= 0) ? 0 : 1;
> >> +}
> >> +
> >> +static int yaffs_checkpt_erase(struct yaffs_dev *dev)
> >> +{
> >> +	int i;
> >> +
> >> +	if (!dev->param.erase_fn)
> >> +		return 0;
> >> +	yaffs_trace(YAFFS_TRACE_CHECKPOINT,
> >> +		"checking blocks %d to %d",
> >> +		dev->internal_start_block, dev->internal_end_block);
> >> +
> >> +	for (i = dev->internal_start_block; i <= dev->internal_end_block; i++)
> >> {
> >
> > Why does 'i' need 'function scope'? can't it just have 'for scope'?
> >
> >      for (int i = dev->internal_start_block; i <=
> > dev->internal_end_block; i++) {
>
> Because we don't do that in kernel code.
>
> ryan@okiwi:linux-2.6$ grep "for (int" * -R | wc -l
> 16
>
> Those sixteen should be fixed :-). Half of them are in drivers/staging.

It is also not very portable. For us older codgers it is also very ugly.

-- Charles


