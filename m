Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab0KATTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:19:39 -0400
Received: from smtp.scorch.co.nz ([27.110.127.199]:60747 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751078Ab0KATTg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:19:36 -0400
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 05/29] Staging: yaffs2: yaffs_allocator: Add files
Date: Tue, 2 Nov 2010 08:19:33 +1300
User-Agent: KMail/1.9.10
Cc: Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <1288636877-7964-6-git-send-email-tdent48227@gmail.com> <AANLkTikgq2uAW5ko0qG5fe+w-LGvwiV6z3Oi51V_QuiK@mail.gmail.com>
In-Reply-To: <AANLkTikgq2uAW5ko0qG5fe+w-LGvwiV6z3Oi51V_QuiK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201011020819.33777.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 November 2010 07:58:49 Pekka Enberg wrote:
> On Mon, Nov 1, 2010 at 8:40 PM, Tracey Dent <tdent48227@gmail.com> wrote:
> > Adding files to yaffs2 directory.
> >
> > Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> > ---
> >  drivers/staging/yaffs2/yaffs_allocator.c |  408
> > ++++++++++++++++++++++++++++++ drivers/staging/yaffs2/yaffs_allocator.h |
> >   30 +++
> >  2 files changed, 438 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/staging/yaffs2/yaffs_allocator.c
> >  create mode 100644 drivers/staging/yaffs2/yaffs_allocator.h
> >
> > diff --git a/drivers/staging/yaffs2/yaffs_allocator.c
> > b/drivers/staging/yaffs2/yaffs_allocator.c new file mode 100644
> > index 0000000..024ee2a
> > --- /dev/null
> > +++ b/drivers/staging/yaffs2/yaffs_allocator.c
> > @@ -0,0 +1,408 @@
> > +/*
> > + * YAFFS: Yet Another Flash File System. A NAND-flash specific file
> > system. + *
> > + * Copyright (C) 2002-2010 Aleph One Ltd.
> > + *   for Toby Churchill Ltd and Brightstar Engineering
> > + *
> > + * Created by Charles Manning <charles@aleph1.co.uk>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +
> > +
> > +#include "yaffs_allocator.h"
> > +#include "yaffs_guts.h"
> > +#include "yaffs_trace.h"
> > +#include "yportenv.h"
> > +
> > +#ifdef CONFIG_YAFFS_YMALLOC_ALLOCATOR
> > +
> > +void yaffs_deinit_raw_tnodes_and_objs(yaffs_dev_t *dev)
> > +{
> > +       dev = dev;
> > +}
> > +
> > +void yaffs_init_raw_tnodes_and_objs(yaffs_dev_t *dev)
> > +{
> > +       dev = dev;
> > +}
> > +
> > +yaffs_tnode_t *yaffs_alloc_raw_tnode(yaffs_dev_t *dev)
> > +{
> > +       return (yaffs_tnode_t *)YMALLOC(dev->tnode_size);
> > +}
> > +
> > +void yaffs_free_raw_tnode(yaffs_dev_t *dev, yaffs_tnode_t *tn)
> > +{
> > +       dev = dev;
> > +       YFREE(tn);
> > +}
>
> So you have your own dynamic memory allocator? What's wrong with kmalloc()?

No. YMALLOC() wraps kmalloc() to keep the code portable.

This code does a home-grown slab allocator. The reason for doing this is that 
Linux slab does not allow slab caches to be destroyed while objects exist. 

While that might sound like a dangerous practice, it does mean that when yaffs 
unmounts it can drop all the data structures without having to walk all the 
trees freeing the objects.



