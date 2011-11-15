Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1KOA6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:58:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:23556 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab1KOA6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:58:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,512,1315206000"; 
   d="scan'208";a="74864500"
Message-ID: <1321318714.13860.54.camel@yhuang-dev>
Subject: Re: Printk mulitple line message support
From: Huang Ying <ying.huang@intel.com>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Joe Perches <joe@perches.com>,
        William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Nov 2011 08:58:34 +0800
In-Reply-To: <20111114192026.73afb5b8@neptune.home>
References: <1321253936.13860.35.camel@yhuang-dev>
	 <1321281640.2004.6.camel@Joe-Laptop> <20111114192026.73afb5b8@neptune.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 02:20 +0800, Bruno Prémont wrote:
> On Mon, 14 November 2011 Joe Perches <joe@perches.com> wrote:
> 
> > On Mon, 2011-11-14 at 14:58 +0800, Huang Ying wrote:
> > > Hi,
> > > 
> > > In most cases, printk only guarantees messages from different printk
> > > calling will not be interleaved between each other.  But many printk
> > > users uses multiple line to form a complete message and call printk
> > > for each line.  So the following situation is possible for two printk
> > > users running on two CPUs.
> > > 
> > > line 1 of message from printk user1
> > > line 1 of message from printk user2
> > > line 2 of message from printk user1
> > > line 2 of message from printk user2
> > > 
> > > This makes kernel log hard to read.  One possible solution to this
> > > issue is to give a sequence number (or ID) to each complete message.
> > > So the above lines will be:
> > > 
> > > {1}line 1 of message from printk user1
> > > {2}line 1 of message from printk user2
> > > {1}line 2 of message from printk user1
> > > {2}line 2 of message from printk user2
> > > 
> > > Then some simple script can be used to group lines together according
> > > to sequence number in lines.
> > > 
> > > What do you think about that?
> > 
> > This makes the typical multi-part but non-interleaved
> > output difficult to read.
> > 
> > How about determining if there is interleaving and
> > emitting sequence # only in those cases?
> > 
> > Perhaps test the atomic for the last sequence #.
> 
> Wouldn't another option be to let printk() handle '\n' in messages
> so the multi-line messages could be done with a single call to printk.
> 
> Those messages could contain optional severity information after the
> linefeed (if none given, the one of previous line would be repeated
> internally by printk).
> 
> This way consumers of printk (and all variations of it like dev_err)
> would all benefit without need to redefine them for multi-line use.

Yes.  That is another solution.  But sometimes, it is just not so
convenient to do that.  The printk users may have to allocate a big
buffer to hold all these lines.  The solution here is for those users.

Best Regards,
Huang Ying


