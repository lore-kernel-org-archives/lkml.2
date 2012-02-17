Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2BQVqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:46:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49236 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2BQVqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:46:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.190.8 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Fri, 17 Feb 2012 13:46:04 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Matthew Garrett <mjg@redhat.com>
cc: Holger Macht <holger@homac.de>, Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: linux-next: dock_link_device is oopsy
Message-ID: <alpine.LSU.2.00.1202171320590.5994@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew,

A linux-next oops at bootup in dock_link_device() tells me that you
were not feeling well when you wrote that and dock_unlink_device():
I hope you're feeling better now and can rewrite them soon.

I think my particular problem comes from dock_station_count 0,
so kmalloc() returns NULL, which you don't check for.  But those
functions appear to be minor masterpieces of doing things in the
wrong order, not checking allocation, not freeing resource on failure.

I'm not attaching a proposed patch because, on that record, I bet when
you look closer you'll find more wrong that I wouldn't know about.

Let's hope this isn't diverted into an endless discussion of whether
you ought to use kaalloc() or kballoc() or ....  me, I'd just like to
boot, and have put #if 0..#endif around everything in those functions.

Hugh
