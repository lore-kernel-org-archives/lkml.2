Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2FEUoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:44:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47758 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751882Ab2FEUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:44:16 -0400
Date: Tue, 5 Jun 2012 16:44:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Ming Lei <ming.lei@canonical.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
In-Reply-To: <20120605202137.GD27297@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1206051639430.1179-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Greg Kroah-Hartman wrote:

> > On the whole, it might be easier just to hold the device lock during 
> > the shutdown call.
> 
> That sounds much simpler to me.

Maybe use device_trylock() in a loop, and if the lock can't be acquired 
within a second or so, either call the shutdown method without the lock 
or else skip the device entirely.

That way, crashed or buggy drivers will have less chance of interfering 
with system shutdown.

Alan Stern

