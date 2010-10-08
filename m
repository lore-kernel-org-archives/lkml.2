Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab0JHOCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:02:25 -0400
Received: from smtp.nokia.com ([147.243.1.47]:60257 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab0JHOCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:02:23 -0400
Subject: Re: [PATCH] bdi: use deferable timer for sync_supers task
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: "Wu, Xia" <xia.wu@intel.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <jaxboe@fusionio.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20101008102709.GA12682@ywang-moblin2.bj.intel.com>
References: <20101008083514.GA12402@ywang-moblin2.bj.intel.com>
	 <20101008092520.GB5426@lst.de>
	 <A24AE1FFE7AEC5489F83450EE98351BF227AB58D43@shsmsx502.ccr.corp.intel.com>
	 <1286532586.2095.55.camel@localhost>
	 <A24AE1FFE7AEC5489F83450EE98351BF227AB58D51@shsmsx502.ccr.corp.intel.com>
	 <1286533687.2095.58.camel@localhost>
	 <20101008102709.GA12682@ywang-moblin2.bj.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 08 Oct 2010 16:59:21 +0300
Message-ID: <1286546361.2095.92.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 18:27 +0800, Yong Wang wrote:
> On Fri, Oct 08, 2010 at 01:28:07PM +0300, Artem Bityutskiy wrote:
> > On Fri, 2010-10-08 at 18:27 +0800, Wu, Xia wrote:
> > > > However, when the next wake-up interrupt happens is not defined. It can
> > > > happen 1ms after, or 1 minute after, or 1 hour after. What Christoph
> > > > says is that there should be some guarantee that sb writeout starts,
> > > > say, within 5 to 10 seconds interval. Deferrable timers do not guarantee
> > > > this. But take a look at the range hrtimers - they do exactly this.
> > > 
> > > If the system is in sleep state, is there any data which should be written?
> > 
> > May be yes, may be no.
> > 
> 
> Thanks for the quick response, Artem. May I know what might need to be
> written out when system is really idle?

I do not understand the question. There is dirty data, and it should be
flushed within some time interval.

Anyway, to make the long story short, I made an attempt to optimize this
and stop arming the timer when we have no dirty data. But my solution
was not accepted and Al asked me to just get rid of this timer and whole
sync_supers(). He said this should be pushed down to individual FSes. I
guess the idea is that

1) some FSes actually abuse sb synching, e.g., JFFS2.
2) other FSes can eventually optimize things for themselves.

But I did not find time to do this so far.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

