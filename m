Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1AUAbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:31:48 -0500
Received: from borg.medozas.de ([188.40.89.202]:49731 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab1AUAbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:31:47 -0500
Date: Fri, 21 Jan 2011 01:31:45 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>
Subject: loop: busywait for release?
Message-ID: <alpine.LNX.2.01.1101210124270.982@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to the principal editors of drivers/block/loop.c,

Hi,


I have here a program that sets up a loop device, does its
(quite minimal) work and releases the loop device again.

As soon as a loop device is set up using LOOP_SET_FD, userspace
programs like udev immediately pounce on the loop device for fstype
identification and whatnot, and render the release of the device
futile with -EBUSY.

I could retry until EBUSY is no longer returned, however, since I see
nothing in the loop device driver that could help fence off _new
openers_, EBUSY may be encountered indefinitely.

I reckon vfsmounts have the same issue, though one can use `umount -l` 
to fence new processes off, and then (if desired) kill existing ones.

What is the preferred way to solve this for loop?


thanks,
Jan
