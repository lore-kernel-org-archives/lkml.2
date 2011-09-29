Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1I2ThU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:37:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34776 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1I2ThS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:37:18 -0400
Date: Thu, 29 Sep 2011 12:37:15 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, stable-review@kernel.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-Id: <20110929123715.004f4651.akpm00@gmail.com>
In-Reply-To: <20110929190855.GA5381@suse.de>
References: <20110929175716.GA5815@suse.de>
	<f27ffef8-9ec1-4254-bb26-1f2fdf4366c7@zmail05.collab.prod.int.phx2.redhat.com>
	<20110929190855.GA5381@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 12:08:55 -0700
Greg KH <gregkh@suse.de> wrote:

> > And in fact, upon further reflection, I think maybe that particular
> > test could use being split into two distinct tests.  One for wrapping
> > the byte counter, which would return -ENOMEM, and one for exceeding
> > RLIMIT_MSGQUEUE which would return -EPERM (not sure if that's right, I
> > would have to poke around elsewhere, but it seems a better response
> > when you are violating a ulimit than nomem to me anyway).
> 
> Ok, care to get the patch into Linus's tree and then I can take it into
> stable?

Doug, the thing to do here is to rework your recent mqueue patchset. 
Prepare a minimal, critical-stuff series of bugfix patches against
current Linus mainline which is also applicable to -stable.  We can
merge that into 3.1 or, more likely, into 3.2-rc1/3.1.x.

Then, later, we can merge up the less critical parts of that patchset.

otoh, the only not-applicable-to-stable part of that patchset appears
to be "[1/5] ipc/mqueue: cleanup definition names and locations" and
it's fairly small.  So we could perhaps just merge all five into
3.2-rc1, with a -stable backport.

Doing that backport would require that we first backport the buggy
patches (ie: this one), which is a bit weird.  Perhaps it would be
better for you to prepare a reworked patch series for 3.0.x after
that five-patch series hits mainline.
