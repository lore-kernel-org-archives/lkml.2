Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab0LEWuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 17:50:40 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:33151 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753981Ab0LEWuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 17:50:39 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 7/8] Add yaffs2 file system: verification code and other headers
Date: Mon, 6 Dec 2010 11:50:36 +1300
User-Agent: KMail/1.9.10
Cc: Charles Manning <cdhmanning@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <201012061020.36345.manningc2@actrix.gen.nz> <4CFC0808.9060502@bluewatersys.com>
In-Reply-To: <4CFC0808.9060502@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012061150.36791.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010 10:45:44 Ryan Mallon wrote:
> On 12/06/2010 10:20 AM, Charles Manning wrote:
> > On Friday 03 December 2010 09:00:18 Ryan Mallon wrote:
> >> On 12/01/2010 10:57 AM, Charles Manning wrote:
> >>> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> >>> ---
> >>
> >> <snip>
> >>
> >>> diff --git a/fs/yaffs2/yportenv.h b/fs/yaffs2/yportenv.h
> >>> new file mode 100644
> >>> index 0000000..8fd0da5
> >>> --- /dev/null
> >>> +++ b/fs/yaffs2/yportenv.h
> >>> @@ -0,0 +1,91 @@
> >>> +/*
> >>> + * YAFFS: Yet another Flash File System . A NAND-flash specific file
> >>> system. + *
> >>> + * Copyright (C) 2002-2010 Aleph One Ltd.
> >>> + *   for Toby Churchill Ltd and Brightstar Engineering
> >>> + *
> >>> + * Created by Charles Manning <charles@aleph1.co.uk>
> >>> + *
> >>> + * This program is free software; you can redistribute it and/or
> >>> modify + * it under the terms of the GNU Lesser General Public License
> >>> version 2.1 as + * published by the Free Software Foundation.
> >>> + *
> >>> + * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
> >>> + */
> >>> +
> >>> +#ifndef __YPORTENV_LINUX_H__
> >>> +#define __YPORTENV_LINUX_H__
> >>> +
> >>> +#include <linux/version.h>
> >>> +#include <linux/kernel.h>
> >>> +#include <linux/mm.h>
> >>> +#include <linux/sched.h>
> >>> +#include <linux/string.h>
> >>> +#include <linux/slab.h>
> >>> +#include <linux/vmalloc.h>
> >>> +#include <linux/xattr.h>
> >>> +#include <linux/list.h>
> >>> +#include <linux/types.h>
> >>> +#include <linux/fs.h>
> >>> +#include <linux/stat.h>
> >>> +#include <linux/sort.h>
> >>> +#include <linux/bitops.h>
> >>> +
> >>> +#define YCHAR char
> >>> +#define YUCHAR unsigned char
> >>> +#define _Y(x)     x
> >>> +#define yaffs_strcat(a, b)     strcat(a, b)
> >>> +#define yaffs_strcpy(a, b)     strcpy(a, b)
> >>> +#define yaffs_strncpy(a, b, c) strncpy(a, b, c)
> >>> +#define yaffs_strncmp(a, b, c) strncmp(a, b, c)
> >>> +#define yaffs_strnlen(s,m)	strnlen(s,m)
> >>> +#define yaffs_sprintf	       sprintf
> >>> +#define yaffs_toupper(a)       toupper(a)
> >>> +#define yaffs_sort(base, n, sz, cmp_fn)	sort(base, n, sz, cmp_fn,
> >>> NULL) +
> >>> +#define Y_INLINE __inline__
> >>> +
> >>> +#define YAFFS_LOSTNFOUND_NAME		"lost+found"
> >>> +#define YAFFS_LOSTNFOUND_PREFIX		"obj"
> >>> +
> >>> +#define YMALLOC(x) kmalloc(x, GFP_NOFS)
> >>> +#define YFREE(x)   kfree(x)
> >>> +#define YMALLOC_ALT(x) vmalloc(x)
> >>> +#define YFREE_ALT(x)   vfree(x)
> >>> +#define YMALLOC_DMA(x) YMALLOC(x)
> >>> +
> >>> +#define YYIELD() schedule()
> >>> +#define Y_DUMP_STACK() dump_stack()
> >>> +
> >>> +#define YAFFS_ROOT_MODE			0755
> >>> +#define YAFFS_LOSTNFOUND_MODE		0700
> >>> +
> >>> +#define Y_CURRENT_TIME CURRENT_TIME.tv_sec
> >>> +#define Y_TIME_CONVERT(x) (x).tv_sec
> >>> +
> >>> +#define yaffs_sum_cmp(x, y) ((x) == (y))
> >>> +#define yaffs_strcmp(a, b) strcmp(a, b)
> >>
> >> You should try and remove the wrappers for as many of these as possible.
> >> I know the wrappers are there for portability to other operating
> >> systems, but for mainlining in Linux it makes the code more complex.
> >
> > Thus far I have tried to keep all the code directly compilable for WinCE
> > and Linux.
> >
> > I did some investigation over the weekend and I am pretty sure that if I
> > preserve just a few of these macros, YCHAR in particular, I can eliminate
> > almost everything else and just run the code through a sed script to
> > generate the WiNCE version.
>
> Could YCHAR and YUCHAR be replaced by s8 and u8?

Not without dropping the WinCE usage. WinCE uses a 16-bit wchar.

There are already places where yaffs uses single byte types (eg. buffers) so 
just changing all chars to wchars will not work.

Using s8 as distinct from char and translating s8 into wchar is too subtle, 
IMHO.

I think I can get it down to YCHAR and _Y() as a wrapper around strings to be 
translated, or very close.

-- Charles

>
> ~Ryan


