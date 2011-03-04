Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab1CDKVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:21:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:40555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274Ab1CDKVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:21:51 -0500
Subject: Re: [PATCH 09/27] nfs: writeback pages wait queue
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Chris Mason <chris.mason@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1299229843.2428.13484.camel@twins>
References: <20110303064505.718671603@intel.com>
	 <20110303074949.809203319@intel.com> <1299168481.1310.56.camel@laptop>
	 <20110304020157.GB7976@localhost>  <1299229843.2428.13484.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Mar 2011 10:26:35 +0100
Message-ID: <1299230795.2428.13486.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 10:10 +0100, Peter Zijlstra wrote:
> On Fri, 2011-03-04 at 10:01 +0800, Wu Fengguang wrote:
> >                         clear_bdi_congested(bdi, BLK_RW_SYNC);
> >                         /*
> >                          * On the following wake_up(), nfs_wait_congested()
> >                          * will see the cleared bit and quit.
> >                          */
> >                         smp_mb__after_clear_bit();
> >                 }
> >                 if (waitqueue_active(&wqh[BLK_RW_SYNC]))
> >                         wake_up(&wqh[BLK_RW_SYNC]); 
> 
> If I tell you that: try_to_wake_up() implies an smp_wmb(), do you then
> still need this?

Also, there is no matching rmb,mb in nfs_wait_congested().. barrier
always come in pairs.
