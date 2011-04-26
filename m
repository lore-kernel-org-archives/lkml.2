Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1DZL3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:29:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41206 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1DZL3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f2jA+zzCeatycRrlWjAX7EPOVWR07+NJkzinLMDvMRRTh/7l2B474+clf8r1gKIBSE
         rcI0Zgs/1fIphXMtuLjMu+9YxlqEzbzpksZMbGNn63YOCd+m+2QqTQTJN94qlEOeIuE/
         hIcmDfgb8cvGXhwFkCZNedWDh1Njkt5I7ZmXE=
Date: Tue, 26 Apr 2011 13:29:05 +0200
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC]block: add flush request at head
Message-ID: <20110426112905.GC878@htj.dyndns.org>
References: <1303112174.3981.187.camel@sli10-conroe>
 <4DABF194.4010603@fusionio.com>
 <1303115157.3981.198.camel@sli10-conroe>
 <20110422225704.GA1576@mtj.dyndns.org>
 <1303693319.3981.272.camel@sli10-conroe>
 <20110425082103.GA17734@mtj.dyndns.org>
 <1303778955.3981.285.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303778955.3981.285.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Apr 26, 2011 at 08:49:15AM +0800, Shaohua Li wrote:
> On Mon, 2011-04-25 at 16:21 +0800, Tejun Heo wrote:
> > Hello, Shaohua.
> > 
> > On Mon, Apr 25, 2011 at 09:01:59AM +0800, Shaohua Li wrote:
> > > this is a regression from 2.6.39-rc2 compared to 2.6.39-rc1, so this
> > > isn't related to the flush rewritten. Workload is sysbench fileio,
> > > please see the first mail at the thread for detail.
> > 
> > Understood.  Let's talk on the other thread.
>
> This issue isn't related to the optimization patch in another thread.
> And that patch can't recover the regression, which does improve
> throughput even without the regression. So please look at issue again.

IIUC, the regression happened because, before, back-to-back flushes
were basically optimized out by hardware but, after, due to regular
writes thrown into the mix, aren't.  If that's the case, I would still
prefer to solve this from issue side instead of completion if possible
(it might not be tho).

Or is the latency introduced for each flush actually making difference
for the specific benchmark?  Hmmm... maybe that's the case given that
your patches merging back-to-back flushes doesn't recover the whole
regression.

I don't know.  Darrick, can you please chime in?  Do you see
regression between front and back queueing of flushes?  The original
thread is

 http://thread.gmane.org/gmane.linux.kernel/1127779

and the offending commit is 53d63e6b0dfb95882ec0219ba6bbd50cde423794
(block: make the flush insertion use the tail of the dispatch list).

Thanks.

-- 
tejun
