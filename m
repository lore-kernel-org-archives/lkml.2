Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab2EUU3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:29:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab2EUU3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:29:19 -0400
Date: Mon, 21 May 2012 16:29:04 -0400
From: Dave Jones <davej@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
Message-ID: <20120521202904.GB12123@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Lameter <cl@linux.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20120517213120.GA12329@redhat.com>
 <20120518185851.GA5728@redhat.com>
 <20120521154709.GA8697@redhat.com>
 <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com>
 <20120521200118.GA12123@redhat.com>
 <alpine.DEB.2.00.1205211510480.10940@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205211510480.10940@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 03:18:38PM -0500, Christoph Lameter wrote:
 > On Mon, 21 May 2012, Dave Jones wrote:
 > 
 > > On Mon, May 21, 2012 at 12:39:19PM -0700, Linus Torvalds wrote:
 > >
 > >  > But there's not a lot of recent stuff. The thing that jumps out is Mel
 > >  > Gorman's recent commit cc9a6c8776615 ("cpuset: mm: reduce large
 > >  > amounts of memory barrier related damage v3"), which has a whole new
 > >  > loop with that scary mpol_cond_put() usage. And there's we had
 > >  > problems with vma merging..
 > >  >
 > >  > Dave, how recent is this problem? Have you already tried older kernels?
 > >
 > > I tried bisecting, but couldn't find a 'good' kernel.
 > > I Went back as far as 3.0, before that I kept running into compile failures.
 > > Newer gcc/binutils really seems to dislike 2.6.x now.
 > 
 > Well binary distro kernels are available that allow easy testing. Will try
 > with what I got here. I have reproduced it with 3.4 so far.
 >
 > Its always an mput on a freed memory policy. Slub recovery keeps my system
 > up at least. I just get the errors dumped to dmesg.

interesting. after it's happened 1-2 times for me, it seems things get really
corrupted, and I start seeing spinlock errors, and soft lockup messages, then hard lockup.
 
 > Is there any way to get the trinity tool to stop when the kernel writes
 > errors to dmesg?

hmm, I added a test a while ago to stop when /proc/sys/kernel/tainted changes,
but maybe that broke. I'll take a look.  (Of course if you start the tool
after already tainted, it'll ignore it).

 >  That way I could see the parameters passed to mbind?

It does create log files in the current dir with the parameters used.
You should be able to grep for the pid that caused the actual oops.

	Dave

