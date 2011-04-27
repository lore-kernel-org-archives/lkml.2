Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1D0Hqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 03:46:54 -0400
Received: from trent.utfs.org ([194.246.123.103]:45661 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab1D0Hqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 03:46:53 -0400
Date: Wed, 27 Apr 2011 00:46:51 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110427022655.GE12436@dastard>
Message-ID: <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard> <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org> <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org> <20110427022655.GE12436@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 at 12:26, Dave Chinner wrote:
> What this shows is that VFS inode cache memory usage increases until
> about the 550 sample mark before the VM starts to reclaim it with
> extreme prejudice. At that point, I'd expect the XFS inode cache to
> then shrink, and it doesn't. I've got no idea why the either the

Do you remember any XFS changes past 2.6.38 that could be related to 
something like this?

Bisecting is pretty slow on this machine. Could I somehow try to run 
2.6.39-rc4 but w/o the XFS changes merged after 2.6.38? (Does someone know 
how to do this via git?)

> Can you check if there are any blocked tasks nearing OOM (i.e. "echo
> w > /proc/sysrq-trigger") so we can see if XFS inode reclaim is
> stuck somewhere?

Will do, tomorrow.

Should I open a regression bug, so we don't loose track of this thing?

Thanks,
Christian.
-- 
BOFH excuse #425:

stop bit received
