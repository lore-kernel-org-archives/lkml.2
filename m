Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab0ITX37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:29:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:55940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab0ITX37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:29:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,395,1280732400"; 
   d="scan'208";a="839386493"
Subject: Re: [patch]cfq-iosched: schedule dispatch for noidle queue
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
In-Reply-To: <20100920140242.GD6138@redhat.com>
References: <1284972817.6598.19.camel@sli10-conroe.sh.intel.com>
	 <20100920140242.GD6138@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 07:29:56 +0800
Message-ID: <1285025396.1668.4.camel@shli-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 22:02 +0800, Vivek Goyal wrote:
> On Mon, Sep 20, 2010 at 04:53:37PM +0800, Shaohua Li wrote:
> > A queue is idle at cfq_dispatch_requests(), but it gets noidle later for
> > different reasons. Unless other task explictly does unplug or all requests
> > are drained, we will not deliever requests to the disk even cfq_arm_slice_timer
> > doesn't make the queue idle. For example, cfq_should_idle() returns true
> > because of service_tree->count == 1, and then other queues are added.
> > Note, I didn't see obvious performance impacts so far with the patch, but
> > just thought this could be a problem.
> > 
> 
> Shaohua Li,
> 
> What are those reasons when an idling queue becomes a non idle one
> (without getting a new request in the queue)?
OOps, I used to add a new reason for another patch but forgot to update
the comment. So this is the only reason.

Thanks,
Shaohua

