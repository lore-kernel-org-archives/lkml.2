Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0CQPaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:30:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40285 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752335Ab0CQPaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:30:19 -0400
Date: Wed, 17 Mar 2010 11:30:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Block device files and the page cache
In-Reply-To: <20100317102252.GT5768@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1003171129200.1734-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010, Jens Axboe wrote:

> On Tue, Mar 16 2010, Alan Stern wrote:
> > Jens and Al:
> > 
> > Simple testing seems to show that when a program closes a file
> > descriptor for a block device file, the release method in the device
> > driver's block_device_operations structure doesn't get called (and the
> > close(2) system call doesn't return) until all the dirty pages for that 
> > device have been written out.
> > 
> > Can anyone confirm that this always happens?  Where in the kernel 
> > source is this handled?
> 
> Alan, see fs/block_dev.c:__blkdev_put(). The last put of the device will
> sync the device before calling fops->release().

Ah, that's where it is!  Thanks very much.

Alan Stern

