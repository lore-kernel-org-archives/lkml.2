Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0LXMmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 07:42:36 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54551 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0LXMm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 07:42:26 -0500
Message-Id: <20101224122338.172750730@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 24 Dec 2010 13:23:38 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 00/17] sched: Reduce runqueue lock contention -v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the latest incarnation of my scary ttwu patch, its split up into
tiny little pieces because at some point while working on the feedback from
the last posting it all stopped working and tiny changes was the only way
to find out wth I done wrong (I never did find out though, when I
completely rewrote everything in tiny chunks it all magically worked again
-- so I guess tglx is chuckling now).

Anyway, it still need a few more loose ends fixed, esp on 32bit there is
the whole unlocked remote min_vruntime access where we can read partial
updates and screw the timeline like problem. And I suppose there's a few
more XXXs in there where I know things are needing TLC.

Also, I bet the eagle eyed lot Cc'ed will spot more holes, as all this is
scary stuff :-)

Anyway, lots of thanks to Frank, Oleg, Ingo and others who commented on
the last posting.

I guess most everybody is out having x-mas celebrations (and I will too not
too long from now), so I expect replies to this won't happen until the new
year, but who knows, maybe in between eating and drinking too much we all
get an urge to stare at code.

Happy Holidays!

