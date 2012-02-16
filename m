Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2BPNso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:48:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51543 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab2BPNsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:48:41 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 16 Feb 2012 14:48:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 05/11] firewire-sbp-target: Add sbp_configfs.c
Message-ID: <20120216144803.27ef3a33@stein>
In-Reply-To: <4F3CD307.4020008@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-6-git-send-email-bootc@bootc.net>
	<20120215202135.61165ee0@stein>
	<4F3CD307.4020008@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16 Chris Boot wrote:
> On 15/02/2012 19:21, Stefan Richter wrote:
> > On Feb 15 Chris Boot wrote:
> >> +	sbp_workqueue = alloc_workqueue("firewire-sbp-target", WQ_UNBOUND, 0);
> >> +	if (!sbp_workqueue) {
> >> +		target_fabric_configfs_deregister(fabric);
> >> +		return -ENOMEM;
> >> +	}
> >
> > What are your specific requirements that you cannot use one of the
> > system-wide workqueues?
> 
> Nothing specific, I just thought it was sensible to use your own 
> workqueue if you put enough work into it. I'll switch to the system queues.

OK, good.  These days you can throw almost any kind of work into the
system workqueues without negative effect on their other users, given you
keep the queue properties in mind which are listed in linux/workqueue.h.
There is also some info in Documentation/workqueue.txt.  If that still
leaves any doubt, you could Cc: Tejun Hejo on questions on the workqueue
infrastructure and he will likely give a helpful hint.

BTW, the drivers/firewire/ subsystem uses an own workqueue instead of the
system-wide ones because of combined requirements of non-reentrance and
memory-reclaim safety, explained in the changelog of commit 6ea9e7bbfc38.
-- 
Stefan Richter
-=====-===-- --=- =----
http://arcgraph.de/sr/
