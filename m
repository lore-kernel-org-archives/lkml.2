Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1GOVhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 17:37:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48312 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1GOVhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 17:37:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 15 Jul 2011 23:35:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>, <osd-dev@open-osd.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
Message-ID: <20110715233522.66fd988f@stein>
In-Reply-To: <4E208302.9020908@panasas.com>
References: <4E1D6900.6040500@cam.ac.uk>
	<20110713144119.6e28dc03@stein>
	<4E208302.9020908@panasas.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 15 Boaz Harrosh wrote:
> On 07/13/2011 05:41 AM, Stefan Richter wrote:
> > osd_uld.c::osd_minor_ida is accessed unsafely.
> > Device probe() and remove() methods are not globally serialized.
> 
> Sorry for the delay. Vacation
> 
> Thanks Stefan I'll look into it. I remember I thought about
> it and tested it at the time, but I might be wrong. I'll look
> into it.

Could actually be that there was or even still is some degree of
serialization by the SCSI core in typical usage.  But I think the
general case is nowadays fully concurrent.  E.g.
    echo $name > /sys/bus/scsi/drivers/osd*/{,un}bind
if issued in parallel for different device names.  Though it is probably
borderline impossible to actually hit a concurrent osd_minor_ida access on
purpose.
-- 
Stefan Richter
-=====-==-== -=== -====
http://arcgraph.de/sr/
