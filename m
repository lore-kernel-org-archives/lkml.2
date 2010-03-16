Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab0CPRIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:08:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50656 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759845Ab0CPRIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:08:46 -0400
Date: Tue, 16 Mar 2010 13:08:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>
cc: linux-fsdevel@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Block device files and the page cache
Message-ID: <Pine.LNX.4.44L0.1003161258280.1307-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens and Al:

Simple testing seems to show that when a program closes a file
descriptor for a block device file, the release method in the device
driver's block_device_operations structure doesn't get called (and the
close(2) system call doesn't return) until all the dirty pages for that 
device have been written out.

Can anyone confirm that this always happens?  Where in the kernel 
source is this handled?

Thanks,

Alan Stern

