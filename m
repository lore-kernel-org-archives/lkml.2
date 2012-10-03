Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2JCJrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:47:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab2JCJrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:47:36 -0400
Date: Wed, 3 Oct 2012 10:47:32 +0100
From: Mel Gorman <mgorman@suse.de>
To: Rick Jones <rick.jones2@hp.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
Message-ID: <20121003094732.GQ29125@suse.de>
References: <20121002065143.GK29125@suse.de>
 <1349164176.7086.43.camel@marge.simpson.net>
 <20121002084501.GL29125@suse.de>
 <506B6F59.8060800@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <506B6F59.8060800@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 03:48:57PM -0700, Rick Jones wrote:
> On 10/02/2012 01:45 AM, Mel Gorman wrote:
> 
> >SIZE=64
> >taskset -c 0 netserver
> >taskset -c 1 netperf -t UDP_STREAM -i 50,6 -I 99,1 -l 20 -H 127.0.0.1 -- -P 15895 -s 32768 -S 32768 -m $SIZE -M $SIZE
> 
> Just FYI, unless you are running a hacked version of netperf, the
> "50" in "-i 50,6" will be silently truncated to 30.
> 

I'm not using a hacked version of netperf. The 50,6 has been there a long
time so I'm not sure where I took it from any more. It might have been an
older version or me being over-zealous at the time.

> PS - I trust it is the receive-side throughput being reported/used
> with UDP_STREAM :)

Good question. Now that I examine the scripts, it is in fact the sending
side that is being reported which is flawed. Granted I'm not expecting any
UDP loss on loopback and looking through a range of results, the
difference is marginal. It's still wrong to report just the sending side
for UDP_STREAM and I'll correct the scripts for it in the future.

Thanks!

-- 
Mel Gorman
SUSE Labs
