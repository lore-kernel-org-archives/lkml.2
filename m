Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2JVVjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:39:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab2JVVjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:39:41 -0400
Date: Mon, 22 Oct 2012 14:39:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB
 v6
Message-Id: <20121022143940.6bf8103f.akpm@linux-foundation.org>
In-Reply-To: <20121022132733.GQ16230@one.firstfloor.org>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org>
	<CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com>
	<20121022132733.GQ16230@one.firstfloor.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 15:27:33 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> BTW seriously MAP_UNINITIALIZED? Who came up with that? 
> MAP_COMPLETELY_INSECURE or MAP_INSANE would have been more appropiate.

heh.  It's a NOMMU-only thing.


config MMAP_ALLOW_UNINITIALIZED
	bool "Allow mmapped anonymous memory to be uninitialized"
	depends on EXPERT && !MMU
	default n
	help
	  Normally, and according to the Linux spec, anonymous memory obtained
	  from mmap() has it's contents cleared before it is passed to
	  userspace.  Enabling this config option allows you to request that
	  mmap() skip that if it is given an MAP_UNINITIALIZED flag, thus
	  providing a huge performance boost.  If this option is not enabled,
	  then the flag will be ignored.

	  This is taken advantage of by uClibc's malloc(), and also by
	  ELF-FDPIC binfmt's brk and stack allocator.

	  Because of the obvious security issues, this option should only be
	  enabled on embedded devices where you control what is run in
	  userspace.  Since that isn't generally a problem on no-MMU systems,
	  it is normally safe to say Y here.

	  See Documentation/nommu-mmap.txt for more information.

