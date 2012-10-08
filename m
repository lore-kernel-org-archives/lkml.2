Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2JHTml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 15:42:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2JHTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 15:42:36 -0400
Date: Mon, 8 Oct 2012 12:42:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>, kamezawa.hiroyu@jp.fujitsu.com,
        minchan@kernel.org, shangw@linux.vnet.ibm.com, yinghai@kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + mm-memblock-reduce-overhead-in-binary-search.patch added to
 -mm tree
Message-Id: <20121008124234.3e8c511b.akpm@linux-foundation.org>
In-Reply-To: <20120910115514.GC17437@dhcp22.suse.cz>
References: <20120907235058.A33F75C0219@hpza9.eem.corp.google.com>
	<20120910082035.GA13035@dhcp22.suse.cz>
	<20120910094604.GA7365@hacker.(null)>
	<20120910110550.GA17437@dhcp22.suse.cz>
	<20120910113051.GA15193@hacker.(null)>
	<20120910115514.GC17437@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012 13:55:15 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> > >OK. Thanks for the clarification. The main question remains, though. Is
> > >this worth for memblock_is_memory?
> > 
> > There are many call sites need to call pfn_valid, how can you guarantee all
> > the addrs are between memblock_start_of_DRAM() and memblock_end_of_DRAM(), 
> > if not can this reduce possible overhead ? 
> 
> That was my question. I hoped for an answer in the patch description. I
> am really not familiar with unicore32 which is the only user now.
> 
> > I add unlikely which means that this will not happen frequently. :-)
> 
> unlikely doesn't help much in this case. You would be doing the test for
> every pfn_valid invocation anyway. So the main question is. Do you want
> to optimize for something that doesn't happen often when it adds a cost
> (not a big one but still) for the more probable cases?
> I would say yes if we clearly see that the exceptional case really pays
> off. Nothing in the changelog convinces me about that.

I don't believe Michal's questions have been resolved yet, so I'll keep
this patch on hold for now.

