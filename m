Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0CQKW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:22:56 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:32839 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0CQKWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:22:54 -0400
Date: Wed, 17 Mar 2010 11:22:52 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Block device files and the page cache
Message-ID: <20100317102252.GT5768@kernel.dk>
References: <Pine.LNX.4.44L0.1003161258280.1307-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1003161258280.1307-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16 2010, Alan Stern wrote:
> Jens and Al:
> 
> Simple testing seems to show that when a program closes a file
> descriptor for a block device file, the release method in the device
> driver's block_device_operations structure doesn't get called (and the
> close(2) system call doesn't return) until all the dirty pages for that 
> device have been written out.
> 
> Can anyone confirm that this always happens?  Where in the kernel 
> source is this handled?

Alan, see fs/block_dev.c:__blkdev_put(). The last put of the device will
sync the device before calling fops->release().

-- 
Jens Axboe

