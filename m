Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448Ab2AFXBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:01:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65430 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2AFXBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:01:31 -0500
MIME-Version: 1.0
In-Reply-To: <4F063DD6.5050403@xenotime.net>
References: <20120105191218.42825638a431bc1aba4879de@canb.auug.org.au> <4F063DD6.5050403@xenotime.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2012 15:01:09 -0800
X-Google-Sender-Auth: vATc64Ek_LQtAAfwM0kmr49fqgM
Message-ID: <CA+55aFx7vzez6C5M6EmZPDmkHig-mY=p64vZWWmWWe-nmxH4=w@mail.gmail.com>
Subject: Re: [PATCH -next] fs: fix fs/fs-writeback.c build error
To: Randy Dunlap <rdunlap@xenotime.net>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 4:18 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>
> In linux-next, fs/fs-writeback.c no longer #includes <linux/buffer_head.h>,
> which #included <linux/pagemap.h>, so add that latter header file to
> <linux/writeback.h> to fix the build error:
>
> fs/fs-writeback.c:510:11: error: 'PAGE_CACHE_SHIFT' undeclared (first use in this function)

I would actually suggest:

 - move the whole MIN_WRITEBACK_PAGES #define from the header file to
fs/writeback.c (why expose such a random #define to outside users that
have nothing to do with it?)

 - make sure that fs/fs-writeback.c has that pagemap.h #include.

There's no reason why <linux/writeback.h> should include filemap.h per
se, and there is no reason why it should expose some internal chunking
#define to anybody else.

Wu?

                  Linus
