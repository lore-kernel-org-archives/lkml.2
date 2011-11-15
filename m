Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1KOAuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:50:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:31775 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab1KOAuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:50:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="75508717"
Message-ID: <1321318201.13860.51.camel@yhuang-dev>
Subject: Re: Printk mulitple line message support
From: Huang Ying <ying.huang@intel.com>
To: Joe Perches <joe@perches.com>
Cc: William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Nov 2011 08:50:01 +0800
In-Reply-To: <1321281640.2004.6.camel@Joe-Laptop>
References: <1321253936.13860.35.camel@yhuang-dev>
	 <1321281640.2004.6.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 22:40 +0800, Joe Perches wrote:
> On Mon, 2011-11-14 at 14:58 +0800, Huang Ying wrote:
> > Hi,
> > 
> > In most cases, printk only guarantees messages from different printk
> > calling will not be interleaved between each other.  But many printk
> > users uses multiple line to form a complete message and call printk
> > for each line.  So the following situation is possible for two printk
> > users running on two CPUs.
> > 
> > line 1 of message from printk user1
> > line 1 of message from printk user2
> > line 2 of message from printk user1
> > line 2 of message from printk user2
> > 
> > This makes kernel log hard to read.  One possible solution to this
> > issue is to give a sequence number (or ID) to each complete message.
> > So the above lines will be:
> > 
> > {1}line 1 of message from printk user1
> > {2}line 1 of message from printk user2
> > {1}line 2 of message from printk user1
> > {2}line 2 of message from printk user2
> > 
> > Then some simple script can be used to group lines together according
> > to sequence number in lines.
> > 
> > What do you think about that?
> 
> This makes the typical multi-part but non-interleaved
> output difficult to read.

With a simple script, we can strip out the sequence # easily.

> How about determining if there is interleaving and
> emitting sequence # only in those cases?
> 
> Perhaps test the atomic for the last sequence #.

So we will have no sequence # prefix for printk user1's lines if printk
user 2 comes in the middle?  Something as follow?

line 1 of message from printk user1
{2}line 1 of message from printk user2
line 2 of message from printk user1
{2}line 2 of message from printk user2

This will make it hard for a script to sort the lines.  Where should it
insert lines from printk user2 in the sort result?

Best Regards,
Huang Ying


