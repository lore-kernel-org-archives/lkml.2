Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863Ab2JYOZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:25:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759831Ab2JYOZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:25:08 -0400
Date: Thu, 25 Oct 2012 16:25:06 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
Message-ID: <20121025142506.GH11105@dhcp22.suse.cz>
References: <20121024125439.c17a510e.akpm@linux-foundation.org>
 <50884F63.8030606@linux.vnet.ibm.com>
 <20121024134836.a28d223a.akpm@linux-foundation.org>
 <20121024210600.GA17037@liondog.tnic>
 <50885B2E.5050500@linux.vnet.ibm.com>
 <20121024224817.GB8828@liondog.tnic>
 <5088725B.2090700@linux.vnet.ibm.com>
 <CAHGf_=pfdgoeG5pPJb+UgjqfieU1yxt=46FGW1=th0RbgVKNRQ@mail.gmail.com>
 <20121025092424.GA16601@liondog.tnic>
 <50892917.30201@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50892917.30201@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 25-10-12 04:57:11, Dave Hansen wrote:
[...]
> Here's the problem: Joe Kernel Developer gets a bug report, usually
> something like "the kernel is slow", or "the kernel is eating up all my
> memory".  We then start going and digging in to the problem with the
> usual tools.  We almost *ALWAYS* get dmesg, and it's reasonably common,
> but less likely, that we get things like vmstat along with such a bug
> report.
> 
> Joe Kernel Developer digs in the statistics or the dmesg and tries to
> figure out what happened.  I've run in to a couple of cases in practice
> (and I assume Michal has too) where the bug reporter was using
> drop_caches _heavily_ and did not realize the implications.  It was
> quite hard to track down exactly how the page cache and dentries/inodes
> were getting purged.

Yes, very same here. Not that I would meet issues like that often but it
happened in the past few times and it was always a lot of burnt time.

> There are rarely oopses involved in these scenarios.
> 
> The primary goal of this patch is to make debugging those scenarios
> easier so that we can quickly realize that drop_caches is the reason our
> caches went away, not some anomalous VM activity.  A secondary goal is
> to tell the user: "Hey, maybe this isn't something you want to be doing
> all the time."

-- 
Michal Hocko
SUSE Labs
