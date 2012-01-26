Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2AZAUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 19:20:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2AZAUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 19:20:37 -0500
Date: Wed, 25 Jan 2012 16:20:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: adjust rss counters for migration entiries
Message-Id: <20120125162035.32766a1c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1201251453550.2141@eggly.anvils>
References: <20120106173827.11700.74305.stgit@zurg>
	<20120106173856.11700.98858.stgit@zurg>
	<20120111144125.0c61f35f.kamezawa.hiroyu@jp.fujitsu.com>
	<4F0D46EF.4060705@openvz.org>
	<20120111174126.f35e708a.kamezawa.hiroyu@jp.fujitsu.com>
	<20120118152131.45a47966.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1201231719580.14979@eggly.anvils>
	<4F1E58DD.6030607@openvz.org>
	<alpine.LSU.2.00.1201251453550.2141@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012 15:01:38 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> > > > : From: Konstantin Khlebnikov<khlebnikov@openvz.org>
> > > > : Subject: mm: postpone migrated page mapping reset
> > > > :
> > > > : Postpone resetting page->mapping until the final
> > > > remove_migration_ptes().
> > > > : Otherwise the expression PageAnon(migration_entry_to_page(entry)) does
> > > > not
> > > > : work.
> > > > :
> > > > : Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> > > > : Cc: Hugh Dickins<hughd@google.com>
> > > > : Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > > Isn't this one actually an essential part of the fix?  It should have
> > > been part of the same patch, but you split them apart, now Andrew has
> > > reordered them and pushed one part to 3.3, but this needs to go in too?
> > > 
> > 
> > Oops. I missed that. Yes. race-fix does not work for anon-memory without that
> > patch.
> > But this is non-fatal, there are no new bugs.
> 
> Non-fatal and no new bug, yes, but it makes the fix which has already
> gone in rather less of a fix than was intended (it'll get the total right,
> but misreport anon as file).  Andrew, please add this one to your next
> push to Linus - thanks.

Shall do.
