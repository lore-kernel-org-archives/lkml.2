Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2LGP0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 10:26:02 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36605 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754663Ab2LGP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 10:26:00 -0500
Date: Fri, 7 Dec 2012 10:25:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Subject: Re: Race condition between driver_probe_device and device_shutdown
In-Reply-To: <CACVXFVMOxQEJ-nrvGQ-PkevqKkLnXu+QjHgeswkbzFjqOVYCdQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1212071023090.1565-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2012, Ming Lei wrote:

> > I guess the question is whether the callee is allowed to call
> > device_move(), if not, we're good.
> 
> Not only the callee, and other contexts can change device->parent
> too. Looks rfcomm_tty_open() which calls device_move() is called
> in open() context, so the parent might be changed before unlock(dev->parent)
> in __driver_attach().
> 
> >
> >> Your concern on device_remove() might be correct. Also, I am wondering
> >> if we can walk the 'dpm_list' backwards for device shutdown, which should
> >> be simpler and more reasonable.
> >
> > How would that help?
> 
> device_pm_lock() can prevent device_move() from being running.

That wouldn't prevent problems during unbinding.  Wedson is right; the 
places that lock dev->parent must save a local copy of dev->parent.

Alan Stern

