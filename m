Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243Ab0HMMTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 08:19:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:49917 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934230Ab0HMMTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 08:19:17 -0400
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
From: David Woodhouse <dwmw2@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        zheng.yan@oracle.com
In-Reply-To: <20100708143109.GR15984@think>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
	 <20100708143109.GR15984@think>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 13:19:12 +0100
Message-ID: <1281701952.23680.512.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 10:31 -0400, Chris Mason wrote:
> Neither Yan nor I have been able to reproduce this locally, but a few
> people have now hit it.  Johannes, are you available to try out a
> debugging kernel to try and track this down? 

I have a machine you can log into, with a spare file system that causes
this. It's 200GiB so non-trivial to upload, unless you have a tool like
the xfs one which extracts just the important data structures and leaves
all the data extents and free space as zero.

It was created with the MeeGo 2.6.33.6 kernel -- which I don't think
contains commit 7f0e7bed which is later alleged to be the cause.

I've also tried booting this machine with a current kernel from git,
which includes commit 83ba7b07 which is alleged to be a fix -- and btrfs
still oopses just the same.

btrfsck and btrfs-dump-tree both abort with:
 extent-tree.c:1755: update_space_info: Assertion `!(found->total_bytes < found->bytes_used)' failed.

I can mount it read-only though and read certain things out of it. But
when I boot from it, I hit the BUG().

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

