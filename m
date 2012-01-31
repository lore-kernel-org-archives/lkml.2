Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2AaTs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:48:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab2AaTs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:48:28 -0500
Date: Tue, 31 Jan 2012 11:48:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Niels de Vos <ndevos@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mpatocka@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device
 if fsync() is called for a partition
Message-Id: <20120131114821.c73c4150.akpm@linux-foundation.org>
In-Reply-To: <20120131193748.GA10093@infradead.org>
References: <4F213E1A.4060808@redhat.com>
	<1327584802-14298-1-git-send-email-ndevos@redhat.com>
	<20120126134051.6add3cd2.akpm@linux-foundation.org>
	<20120126214534.GA9319@infradead.org>
	<4F28102C.1070207@redhat.com>
	<20120131105824.c48351b6.akpm@linux-foundation.org>
	<20120131190425.GA10533@infradead.org>
	<20120131113250.816ee772.akpm@linux-foundation.org>
	<20120131193748.GA10093@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 14:37:48 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jan 31, 2012 at 11:32:50AM -0800, Andrew Morton wrote:
> > I didn't say the kernel would support this as-is.
> > 
> > If the partitioning scheme requires writing to the individual
> > partitions then something would need to be done, such as a simple
> > offsetting DM driver.
> 
> Writing partition tables requires writing to them main block device.

This can be done via an offsetting driver.

> Seriously - if people want to support block devices nodes > 16TB dealing
> with this isn't the problem.  They'll need to find a way to do buffered
> I/O without using the pagecache to get it right,

why?  I don't see the problem - supporting /dev/sdaX should be
straightforward.  /dev/sda rarely gets used and would need a bit of
special-case handling.

Please provide all the details as you see them and stop making me email
more questions to you.

> at which point
> blkdev_get_block in either form will simply go away.
