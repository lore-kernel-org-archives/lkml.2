Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0ICUTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:19:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490Ab0ICUTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:19:50 -0400
Date: Fri, 3 Sep 2010 13:19:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH -resend 1/1] HPET: unmap unused I/O space
Message-Id: <20100903131941.06521074.akpm@linux-foundation.org>
In-Reply-To: <1283502474-15379-1-git-send-email-jslaby@suse.cz>
References: <1283502474-15379-1-git-send-email-jslaby@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Sep 2010 10:27:54 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> When the initialization code in hpet founds a memory resource and does
> not found IRQ, it does not unmap the memory resource previously
> mapped.
> 
> There are buggy BIOSes which report resources exactly like this and
> what is worse the memory region bases point to normal RAM. This
> normally would not matter since the space is not touched. But when PAT
> is turned on, ioremap causes the page to be uncached and sets this bit
> in page->flags.
> 
> Then when the page is about to be used by the allocator, it is
> reported as:
> BUG: Bad page state in process md5sum  pfn:3ed00
> page:ffffea0000dbd800 count:0 mapcount:0 mapping:(null) index:0x0
> page flags: 0x20000001000000(uncached)
> Pid: 7956, comm: md5sum Not tainted 2.6.34-12-desktop #1
> Call Trace:
>  [<ffffffff810df851>] bad_page+0xb1/0x100
>  [<ffffffff810dfa45>] prep_new_page+0x1a5/0x1c0
>  [<ffffffff810dfe01>] get_page_from_freelist+0x3a1/0x640
>  [<ffffffff810e01af>] __alloc_pages_nodemask+0x10f/0x6b0

Well damn, good detective work.  I wonder how many of those nasty
random bad-page-state bug reports just got fixed.  I dub thee
September's "Hero of the Linux kernel"!

