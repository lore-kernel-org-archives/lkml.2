Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030800Ab2B2TCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:02:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53114 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964992Ab2B2TCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:02:39 -0500
Message-ID: <1330542157.13689.17.camel@joe2Laptop>
Subject: Re: [PATCH 0/4] jffs2: logging message neatening
From: Joe Perches <joe@perches.com>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 11:02:37 -0800
In-Reply-To: <1330517290.3545.107.camel@sauron.fi.intel.com>
References: <cover.1329349881.git.joe@perches.com>
	 <1330517290.3545.107.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 14:08 +0200, Artem Bityutskiy wrote:
> On Wed, 2012-02-15 at 15:56 -0800, Joe Perches wrote:
> > Joe Perches (4):
> >   jffs2: Convert most D1/D2 macros to jffs2_dbg
> >   jffs2: Convert printks to pr_<level>
> >   jffs2: Use pr_fmt and remove jffs: from formats
> >   jffs2: Standardize JFFS_<LEVEL> uses
> 
> Thanks for the work, appreciated. But your patch introduces new sparse
> and smatch warnings, which did not exist before your patch:

Hello Artem.

> Successfully built configuration "l2_mxs_defconfig,arm,arm-unknown-linux-gnueabi-", results:
> 
> --- before_patching.log
> +++ after_patching.log 
> @@ @@
> +fs/jffs2/file.c:330:2: warning: signed and unsigned type in conditional expression [-Wsign-compare]
> @@ @@
> -fs/jffs2/read.c:154 jffs2_read_dnode(129) warn: possible memory leak of 'decomprbuf' [smatch]
> -fs/jffs2/read.c:154 jffs2_read_dnode(129) warn: possible memory leak of 'readbuf' [smatch]
> +fs/jffs2/read.c:154 jffs2_read_dnode(131) warn: possible memory leak of 'decomprbuf' [smatch]
> +fs/jffs2/read.c:154 jffs2_read_dnode(131) warn: possible memory leak of 'readbuf' [smatch]
> @@ @@
> -fs/jffs2/scan.c:108:54: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
> @@ @@
> +fs/jffs2/super.c:377:1: error: directive in argument list [sparse]
> +fs/jffs2/super.c:379:1: error: directive in argument list [sparse]
> +fs/jffs2/super.c:380:1: error: directive in argument list [sparse]
> +fs/jffs2/super.c:382:1: error: directive in argument list [sparse]

I don't see how this is a new error.
printk vs pr_info shouldn't change this.
maybe it's a smatch issue?


> Would you please take a look? Ideally patches should eliminate warnings,
> not introduce new ones.

I believe this simply exposes a current defect rather than
adds "new" ones.  It seems the old D1/D2 macros hide them.

> Also, your patch does not apply cleanly to my l2-mtd tree - and this is
> the tree which is currently used for merging MTD and JFFS2 stuff
> upstream, and it is in linux-next as well. Would you send patches
> against the l2 tree?

This patchset applies cleanly against next-20120229
Where is your git tree?

cheers, Joe

