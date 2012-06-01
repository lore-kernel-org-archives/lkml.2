Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965488Ab2FAQX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:23:27 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:45387 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965393Ab2FAQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:23:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2012 12:23:23 EDT
Date: Fri, 1 Jun 2012 18:16:40 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
Message-ID: <20120601161640.GA329@x4>
References: <20120530163317.GA13189@redhat.com>
 <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com>
 <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.06.01 at 01:44 -0700, Hugh Dickins wrote:
> On Thu, 31 May 2012, Dave Jones wrote:
> > On Wed, May 30, 2012 at 08:57:40PM -0400, Dave Jones wrote:
> >  > On Wed, May 30, 2012 at 12:33:17PM -0400, Dave Jones wrote:
> >  >  > Just saw this on Linus tree as of 731a7378b81c2f5fa88ca1ae20b83d548d5613dc
> >  >  > 
> >  >  > WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()

I've also hit this warning today:

------------[ cut here ]------------
WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0xea/0x120()
Hardware name: System Product Name
Pid: 4385, comm: firefox Not tainted 3.4.0-09547-gfb21aff-dirty #46
Call Trace:
 [<ffffffff8105c6c0>] ? warn_slowpath_common+0x60/0xa0
 [<ffffffff810ba44a>] ? __set_page_dirty_nobuffers+0xea/0x120
 [<ffffffff810e4db0>] ? migrate_page_copy+0x150/0x160
 [<ffffffff810e4e2d>] ? migrate_page+0x4d/0x80
 [<ffffffff810e4edd>] ? move_to_new_page+0x7d/0x220
 [<ffffffff810c9e40>] ? suitable_migration_target.isra.12+0x1a0/0x1a0
 [<ffffffff810e55a8>] ? migrate_pages+0x3c8/0x460
 [<ffffffff810caa44>] ? compact_zone+0x1c4/0x2c0
 [<ffffffff810cad42>] ? compact_zone_order+0x82/0xc0
 [<ffffffff810cae4a>] ? try_to_compact_pages+0xca/0x140
 [<ffffffff81551f11>] ? __alloc_pages_direct_compact+0xa7/0x18f
 [<ffffffff810b8a30>] ? __alloc_pages_nodemask+0x3b0/0x7a0
 [<ffffffff810e884d>] ? do_huge_pmd_anonymous_page+0x10d/0x2a0
 [<ffffffff8105301b>] ? do_page_fault+0xfb/0x400
 [<ffffffff810d46bd>] ? mmap_region+0x1dd/0x540
 [<ffffffff81559f2f>] ? page_fault+0x1f/0x30
---[ end trace 7d7c821044142576 ]---

-- 
Markus
