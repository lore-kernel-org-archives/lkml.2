Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2BQGrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 01:47:45 -0500
Received: from mail04-md.ns.itscom.net ([175.177.155.114]:56519 "EHLO
	mail04-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2BQGro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 01:47:44 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: hugetlbfs lockdep spew revisited.
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tyler Hicks <tyhicks@canonical.com>, Josh Boyer <jwboyer@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20120217004922.GN23916@ZenIV.linux.org.uk>
References: <20120217000856.GA13112@redhat.com> <20120217001634.GH23550@zod.bos.redhat.com> <20120217003848.GB20071@boyd> <20120217004922.GN23916@ZenIV.linux.org.uk>
Date: Fri, 17 Feb 2012 15:47:41 +0900
Message-ID: <12592.1329461261@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> Sigh...  That patch is correct, but it has nothing to do with the locking
> order violation that really *is* there.  The only benefit would be to
> get rid of the "deadlock is not possible" nonsense, since you would see
> read/write vs. mmap instead of readdir vs. mmap in the traces.  Locking
	:::

How do you think about this patch?

Re: [RFC 0/2] locking order of mm->mmap_sem and various FS
http://marc.info/?l=linux-kernel&m=132124846728745&w=2

Ah, I found mutex_destroy() call in hugetlbfs_destroy_inode() should be
removed.
If you think this approach is good, then I'd post a revised patch.


J. R. Okajima
