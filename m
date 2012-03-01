Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab2CATmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:42:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2CATmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:42:03 -0500
Date: Thu, 1 Mar 2012 11:42:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Greg Thelen <gthelen@google.com>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] writeback: introduce the pageout work
Message-Id: <20120301114201.d1dcacad.akpm@linux-foundation.org>
In-Reply-To: <20120301110404.GC4385@quack.suse.cz>
References: <20120228140022.614718843@intel.com>
	<20120228144747.198713792@intel.com>
	<20120228160403.9c9fa4dc.akpm@linux-foundation.org>
	<20120301110404.GC4385@quack.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012 12:04:04 +0100
Jan Kara <jack@suse.cz> wrote:

> > iirc, the way I "grabbed" the page was to actually lock it, with
> > [try_]_lock_page().  And unlock it again way over within the writeback
> > thread.  I forget why I did it this way, rather than get_page() or
> > whatever.  Locking the page is a good way of preventing anyone else
> > from futzing with it.  It also pins the inode, which perhaps meant that
> > with careful management, I could avoid the igrab()/iput() horrors
> > discussed above.
>
>   I think using get_page() might be a good way to go.

get_page() doesn't pin the inode - truncate() will still detach it
from the address_space().
