Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab2ARNEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:04:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397Ab2ARNEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:04:35 -0500
Date: Wed, 18 Jan 2012 08:04:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, jmoyer@redhat.com, zhu.yanhai@gmail.com
Subject: Re: [RFC 0/3]block: An IOPS based ioscheduler
Message-ID: <20120118130425.GA30204@redhat.com>
References: <20120108221615.GA4198@dastard>
 <1326071375.22361.543.camel@sli10-conroe>
 <20120115224532.GD3174@redhat.com>
 <1326688590.22361.578.camel@sli10-conroe>
 <20120116071132.GE3174@redhat.com>
 <1326700541.22361.607.camel@sli10-conroe>
 <20120116082927.GF3174@redhat.com>
 <1326762388.22361.613.camel@sli10-conroe>
 <20120117090220.GB15511@redhat.com>
 <1326849637.22361.616.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326849637.22361.616.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 09:20:37AM +0800, Shaohua Li wrote:

[..]
> > I think trying to make to make CFQ work (Or trying to come up with CFQ
> > like IOPS scheduler) on these fast devices might not lead us anywhere.
> If only performance matters, I'd rather use noop for ssd. There is
> requirement to have cgroup support (maybe ioprio) to give different
> tasks different bandwidth.

Sure but the issue is that we need to idle in an effort to prioritize
a task and idling kills performance. So you can implement something but
I have doubts that on a fast hardware it is going to be very useful.

Another issue is that with flash based storage, it can drive really deep
queue depths. If that's the case, then just ioscheduler can't solve the
prioritazaion issues (until and unless ioscheduler does not drive deep
queue depths and kills performance). We need some kind of cooperation
from device (like device understanding the notion of iopriority), so
that device can prioritize the requests and one need not to idle. That
way, we might be able to get service differentiation while getting
reasonable throughput.

Thanks
Vivek
