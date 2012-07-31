Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2GaABQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 20:01:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab2GaABI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 20:01:08 -0400
Date: Mon, 30 Jul 2012 20:00:19 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/3] Introduce percpu rw semaphores
In-Reply-To: <20120730170013.GA4778@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.1207301955370.4547@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
 <20120628111541.GB17515@quack.suse.cz> <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
 <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
 <1343508252.2626.13184.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
 <20120730170013.GA4778@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2012, Paul E. McKenney wrote:

> On Sun, Jul 29, 2012 at 01:13:34AM -0400, Mikulas Patocka wrote:
> > On Sat, 28 Jul 2012, Eric Dumazet wrote:
> > > On Sat, 2012-07-28 at 12:41 -0400, Mikulas Patocka wrote:
> 
> [ . . . ]
> 
> > > (bdev->bd_block_size should be read exactly once )
> > 
> > Rewrite all direct and non-direct io code so that it reads block size just 
> > once ...
> 
> For whatever it is worth, the 3.5 Linux kernel only has about ten mentions
> of bd_block_size, at least according to cscope.
> 
> 							Thanx, Paul

plus 213 uses of i_blkbits (which is derived directly from bd_block_size). 
45 of them is in fs/*.c and mm/*.c

Mikulas
