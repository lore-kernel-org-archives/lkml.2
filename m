Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2ADQwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:52:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53242 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756306Ab2ADQwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:52:21 -0500
Date: Wed, 4 Jan 2012 11:52:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Sysfs attributes racing with unregistration
Message-ID: <Pine.LNX.4.44L0.1201041142220.1505-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun:

Can you explain the current situation regarding access to sysfs
attributes and possible races with kobject removal?  I have two
questions in particular:

	What happens if one thread calls an attribute's show or
	store method concurrently with another thread unregistering
	the underlying kobject?

	What happens if a thread continues to hold an open fd 
	reference to a sysfs attribute file after the kobject is
	unregistered, and then tries to read or write that fd?

If there are any guarantees about what happens in these situations, I 
can't find them in the kernel source.

And of course, if you can think of any other matters related to this 
topic, please mention them.

Alan Stern

