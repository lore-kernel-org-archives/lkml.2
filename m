Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0KAT0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:26:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41818 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0KAT0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JbGdymQfH6uycAnrpRGhrgdgTJZoxlLPwyoqsxyTrqfFkJES8Ea0vKZ6OWyuamTQx2
         K7v4UVAyKIJQIaU9NrguP4ave9L7rcxJERKN1g4kXD2Dd/8nGNRy45/6QpPXW663xcot
         qYpI+wfTdnFMllDwdPBo2cLwNJSy5CHrLsdYM=
MIME-Version: 1.0
In-Reply-To: <AANLkTimJw8ZMDGu61z8bEvCL8R94xr9GdAnFkQDtMg+V@mail.gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-6-git-send-email-tdent48227@gmail.com>
	<AANLkTikgq2uAW5ko0qG5fe+w-LGvwiV6z3Oi51V_QuiK@mail.gmail.com>
	<201011020819.33777.manningc2@actrix.gen.nz>
	<AANLkTimJw8ZMDGu61z8bEvCL8R94xr9GdAnFkQDtMg+V@mail.gmail.com>
Date: Mon, 1 Nov 2010 21:25:40 +0200
X-Google-Sender-Auth: sP6pAGTjCea94Yo0EmOd5izcUfo
Message-ID: <AANLkTim8o7mktJVxHYCgfDA6AuGNua4Mmuz4M=Gpiz1p@mail.gmail.com>
Subject: Re: [PATCH 05/29] Staging: yaffs2: yaffs_allocator: Add files
From: Pekka Enberg <penberg@kernel.org>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 9:23 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Mon, Nov 1, 2010 at 9:19 PM, Charles Manning <manningc2@actrix.gen.nz> wrote:
>> On Tuesday 02 November 2010 07:58:49 Pekka Enberg wrote:
>>> On Mon, Nov 1, 2010 at 8:40 PM, Tracey Dent <tdent48227@gmail.com> wrote:
>>> > Adding files to yaffs2 directory.
>>> >
>>> > Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>>> > ---
>>> >  drivers/staging/yaffs2/yaffs_allocator.c |  408
>>> > ++++++++++++++++++++++++++++++ drivers/staging/yaffs2/yaffs_allocator.h |
>>> >   30 +++
>>> >  2 files changed, 438 insertions(+), 0 deletions(-)
>>> >  create mode 100644 drivers/staging/yaffs2/yaffs_allocator.c
>>> >  create mode 100644 drivers/staging/yaffs2/yaffs_allocator.h
>>> >
>>> > diff --git a/drivers/staging/yaffs2/yaffs_allocator.c
>>> > b/drivers/staging/yaffs2/yaffs_allocator.c new file mode 100644
>>> > index 0000000..024ee2a
>>> > --- /dev/null
>>> > +++ b/drivers/staging/yaffs2/yaffs_allocator.c
>>> > @@ -0,0 +1,408 @@
>>> > +/*
>>> > + * YAFFS: Yet Another Flash File System. A NAND-flash specific file
>>> > system. + *
>>> > + * Copyright (C) 2002-2010 Aleph One Ltd.
>>> > + *   for Toby Churchill Ltd and Brightstar Engineering
>>> > + *
>>> > + * Created by Charles Manning <charles@aleph1.co.uk>
>>> > + *
>>> > + * This program is free software; you can redistribute it and/or modify
>>> > + * it under the terms of the GNU General Public License version 2 as
>>> > + * published by the Free Software Foundation.
>>> > + */
>>> > +
>>> > +
>>> > +
>>> > +#include "yaffs_allocator.h"
>>> > +#include "yaffs_guts.h"
>>> > +#include "yaffs_trace.h"
>>> > +#include "yportenv.h"
>>> > +
>>> > +#ifdef CONFIG_YAFFS_YMALLOC_ALLOCATOR
>>> > +
>>> > +void yaffs_deinit_raw_tnodes_and_objs(yaffs_dev_t *dev)
>>> > +{
>>> > +       dev = dev;
>>> > +}
>>> > +
>>> > +void yaffs_init_raw_tnodes_and_objs(yaffs_dev_t *dev)
>>> > +{
>>> > +       dev = dev;
>>> > +}
>>> > +
>>> > +yaffs_tnode_t *yaffs_alloc_raw_tnode(yaffs_dev_t *dev)
>>> > +{
>>> > +       return (yaffs_tnode_t *)YMALLOC(dev->tnode_size);
>>> > +}
>>> > +
>>> > +void yaffs_free_raw_tnode(yaffs_dev_t *dev, yaffs_tnode_t *tn)
>>> > +{
>>> > +       dev = dev;
>>> > +       YFREE(tn);
>>> > +}
>>>
>>> So you have your own dynamic memory allocator? What's wrong with kmalloc()?
>>
>> No. YMALLOC() wraps kmalloc() to keep the code portable.
>>
>> This code does a home-grown slab allocator. The reason for doing this is that
>> Linux slab does not allow slab caches to be destroyed while objects exist.
>>
>> While that might sound like a dangerous practice, it does mean that when yaffs
>> unmounts it can drop all the data structures without having to walk all the
>> trees freeing the objects.
>
> Either way, your home-grown slab allocator is not going to be merged
> this way. You should be using kmem_cache_alloc() and propose proper
> patches on top of mm/sl?b.c.

Btw, just to clarify: Greg might not mind taking it in as-is but it'll
never be promoted to mainline proper this way.
