Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2B0GZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:25:45 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:45758 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454Ab2B0GZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:25:44 -0500
Date: Sun, 26 Feb 2012 22:25:43 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: axboe@kernel.dk
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1359683961.1571598.1330323943766.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1876351746.1571382.1330323287053.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Subject: /dev/loop direction?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I am unsure if you are the right person to approach. I have been
on and off working on sparse file support for the loop device
(think mounting QCOW, VHD, VMDK images, if you are interested
the current patches, which are stale by about three months, are at
https://github.com/andreiw/andreiw-wip/tree/master/linux/3.2/block/loop).

As I look at rebasing my current work on top of the latest linux-next,
I ask myself if this is even the right direction to look at. Loop
device has a lot of existing stuff that I've ended up refactoring
and reshuffling, and while I think I've haven't introduced regressions,
the sheer number of odd scenarios with loop means I probably did and
will again. The existing changes already would be a sisyphean task
to split into manageable patches and merge, and the existing loop
design (rigid IOCTL iface that I can't break and no support for
multiple outstanding I/Os) makes me wonder if I should just make
my work as a device-mapper target. Turns out RedHat as done work
on a dm-loop target that (at least at some point) existed and
looks like a good place to start (it can bypass file I/O where it
makes sense, bmap()ing, which was one direction I wanted to take
loop into with future work).

What are your thoughts? Is extending loop to support sparse images
(and by that direction, also COW/differencing images) appropriate?
Or should I just not worry about /dev/loop and fork off or base
on device-mapper?

A

