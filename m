Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0ITXzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:55:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:56801 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab0ITXz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,396,1280732400"; 
   d="scan'208";a="556449477"
Subject: Re: [patch]cfq-iosched: don't idle if a deep seek queue is slow
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
In-Reply-To: <20100920141541.GE6138@redhat.com>
References: <1284972814.6598.18.camel@sli10-conroe.sh.intel.com>
	 <20100920141541.GE6138@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 07:55:07 +0800
Message-ID: <1285026907.1668.6.camel@shli-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 22:15 +0800, Vivek Goyal wrote:
> On Mon, Sep 20, 2010 at 04:53:34PM +0800, Shaohua Li wrote:
> > If a deep seek queue slowly deliver requests but disk is much faster, idle
> > for the queue just wastes disk throughput. If the queue delevers all requests
> > before half its slice is used, the patch disable idle for it.
> > In my test, application delivers 32 requests one time, the disk can accept
> > 128 requests at maxium and disk is fast. without the patch, the throughput
> > is just around 30m/s, while with it, the speed is about 80m/s. The disk is
> > a SSD, but is detected as a rotational disk. I can configure it as SSD, but
> > I thought the deep seek queue logic should be fixed too, for example,
> > considering a fast raid.
> > 
> 
> Hi Shaohua,
> 
> So you seem to be addressing the issue of storage being fast enough and
> a single queue not being able to keep the storage busy.
> 
> But we have the same issue for non-deep queues for a fast storage. This
> patch will not solve that.
right.

> I think CFQ idling in general is a problem on faster storage. For SSDs we
> can statically detect non-rotational media and disable idling. For faster
> RAIDs we need to find an intellligent way of detection and disable idling.
> 
> One of the suggestions at this year's LSF was to keep idling on only for
> SATA disks and for any SCSI disks we can think of disabling idling by
> default. May be with the help of udev rule.
That makes sense, but shouldn't kernel has some reasonable setting?
completely depending on userspace isn't reliable.

Thanks,
Shaohua

