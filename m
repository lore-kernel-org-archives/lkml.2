Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab2KAXUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:20:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab2KAXUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:20:36 -0400
Date: Thu, 1 Nov 2012 19:20:30 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: shmem_getpage_gfp VM_BUG_ON triggered. [3.7rc2]
Message-ID: <20121101232030.GA25519@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20121025023738.GA27001@redhat.com>
 <alpine.LNX.2.00.1210242121410.1697@eggly.anvils>
 <20121101191052.GA5884@redhat.com>
 <alpine.LNX.2.00.1211011546090.19377@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211011546090.19377@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 04:03:40PM -0700, Hugh Dickins wrote:
 > > I just noticed we had a user report hitting this same warning, but
 > > with a different trace..
 > > 
 > > : [<ffffffff8105b84f>] warn_slowpath_common+0x7f/0xc0
 > > : [<ffffffff8105b8aa>] warn_slowpath_null+0x1a/0x20
 > > : [<ffffffff81143c73>] shmem_getpage_gfp+0x7f3/0x830
 > > : [<ffffffff81158c9d>] ? vma_adjust+0x3ed/0x620
 > > : [<ffffffff81143f02>] shmem_file_aio_read+0x1f2/0x380
 > > : [<ffffffff8118e487>] do_sync_read+0xa7/0xe0
 > > : [<ffffffff8118eda9>] vfs_read+0xa9/0x180
 > > : [<ffffffff8118eeca>] sys_read+0x4a/0x90
 > > : [<ffffffff816226e9>] system_call_fastpath+0x16/0x1b
 > 
 > Equally explicable by Hannes's hypothesis;
 > but useful supporting evidence, thank you.
 > 
 > Except... earlier in the thread you explained how you hacked
 > #define VM_BUG_ON(cond) WARN_ON(cond)
 > to get this to come out as a warning instead of a bug,
 > and now it looks as if "a user" has here done the same.
 > 
 > Which is very much a user's right, of course; but does
 > make me wonder whether that user might actually be davej ;)

indirectly. I made the same change in the Fedora kernel a while ago
to test a hypothesis that we weren't getting any VM_BUG_ON reports.

	Dave

