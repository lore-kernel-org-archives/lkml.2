Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2IDPAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:00:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab2IDPAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:00:32 -0400
Date: Tue, 4 Sep 2012 11:00:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120904150004.GB2603@redhat.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120901021348.GB19535@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120901021348.GB19535@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 07:13:48PM -0700, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Thu, Aug 30, 2012 at 06:07:45PM -0400, Vivek Goyal wrote:
> > Here is one quick and dirty proof of concept patch. It checks for stack
> > depth and if remaining space is less than 20% of stack size, then it
> > defers the bio submission to per queue worker.
> 
> So, it removes breadth-first walking of bio construction by ensuring
> stack overflow never happens by bouncing to workqueue if stack usage
> seems too high.
> 
> I do like removal of breadth-first walking.  It makes failure
> scenarios a lot less mind-bending.  That said, Kent is right that this
> can incur significant overhead for certain configurations, and looking
> at stack usage in block layer is rather nasty both in design and
> implementation.
> 
> If we're gonna need rescuer anyway and can get it right and the
> mechanism can be contained in block proper relatively well, I think it
> would be better to make bread-first walking safe.  Both are nasty in
> their own ways after all.

Hi Tejun,

That's fine. Breadth first walking does make sense given the fact that
storage stack can be arbitrarily deep. And Kent's bio set rescuer patch
is not too bad. So I am fine with pursuing that patch.

Thanks
Vivek
