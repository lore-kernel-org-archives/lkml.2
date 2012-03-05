Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab2CEUEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:04:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2CEUE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:04:28 -0500
Date: Mon, 5 Mar 2012 12:04:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-mm@kvack.org, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: OOM killer even when not overcommiting
Message-Id: <20120305120427.2d11d30e.akpm@linux-foundation.org>
In-Reply-To: <1330977506.1589.59.camel@lappy>
References: <1330977506.1589.59.camel@lappy>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Mar 2012 21:58:26 +0200
Sasha Levin <levinsasha928@gmail.com> wrote:

> Hi all,

> I assumed that when setting overcommit_memory=2 and
> overcommit_ratio<100 that the OOM killer won't ever get invoked (since
> we're not overcommiting memory), but it looks like I'm mistaken since
> apparently a simple mmap from userspace will trigger the OOM killer if
> it requests more memory than available.
>
> Is it how it's supposed to work?  Why does it resort to OOM killing
> instead of just failing the allocation?
>
> Here is the dump I get when the OOM kicks in:
> 
> ...
>
> [ 3108.730350]  [<ffffffff81198e4a>] mlock_vma_pages_range+0x9a/0xa0
> [ 3108.734486]  [<ffffffff8119b75b>] mmap_region+0x28b/0x510
> ...

The vma is mlocked for some reason - presumably the app is using
mlockall() or mlock()?  So the kernel is trying to instantiate all the
pages at mmap() time.


