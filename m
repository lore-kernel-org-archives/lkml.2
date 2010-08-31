Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab0HaOaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:30:13 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59508 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab0HaOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:30:05 -0400
Date: Tue, 31 Aug 2010 16:30:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] init: add sys-wrapper.h
Message-ID: <20100831143003.GA15001@merkur.ravnborg.org>
References: <1283189270-7274-1-git-send-email-namhyung@gmail.com> <1283189270-7274-2-git-send-email-namhyung@gmail.com> <20100830190330.GB12921@merkur.ravnborg.org> <AANLkTimysA_CmWVBOntV9bzUBy9Vbhi1MtUJQJAHbQxq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimysA_CmWVBOntV9bzUBy9Vbhi1MtUJQJAHbQxq@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> /*
>  * wrappers for various syscalls for use in the init code
>  *
>  * Copyright (C) 2010  Namhyung Kim <namhyung@gmail.com>
>  *
>  * This file is released under the GPLv2.
>  */
> 
> #include <linux/syscalls.h>
> #include <linux/dirent.h>
> #include <linux/types.h>
> #include <linux/fs.h>
> 
> #include <asm/uaccess.h>
> 

Good.
Except that we usually recommend to include files from include/linux
if thye exist rather than asm/xxx

So use: #include <linux/uaccess.h>


> 
> >> +
> >> +#define kern_sys_call(call, ...)             \
> >> +({                                           \
> >> +     long result;                            \
> >> +     mm_segment_t old_fs = get_fs();         \
> >> +     set_fs(KERNEL_DS);                      \
> >> +     result = call(__VA_ARGS__);             \
> >> +     set_fs(old_fs);                         \
> >> +     result;                                 \
> >> +})
> >> +
> >
> > Personal preference...
> > Replace kern_ with kernel_ all over.
> >
> 
> Is this just your preference or general tendency?
I asked git:
$ git grep kern_ | wc -l
962
$ git grep kernel_ | wc -l
6361

There seems to be preference for kernel_

	Sam
