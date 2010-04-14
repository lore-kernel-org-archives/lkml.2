Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0DNK1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:27:36 -0400
Received: from mga06.intel.com ([134.134.136.21]:40945 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754323Ab0DNK1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:27:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,203,1270450800"; 
   d="scan'208";a="509010292"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os statistics from host side
Date: Wed, 14 Apr 2010 18:27:21 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; x86_64; ; )
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <201004141814.19330.sheng@linux.intel.com> <4BC596C5.7020507@redhat.com>
In-Reply-To: <4BC596C5.7020507@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004141827.21877.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 April 2010 18:19:49 Avi Kivity wrote:
> On 04/14/2010 01:14 PM, Sheng Yang wrote:
> >> I wouldn't like to depend on model specific behaviour.
> >>
> >> One option is to read all the information synchronously and store it in
> >> a per-cpu area with atomic instructions, then queue the NMI.  Another
> >> option is to have another callback which tells us that the NMI is done,
> >> and have a busy loop wait until the NMI is delivered.
> >
> > Callback seems too heavy, may affect the performance badly. Maybe a short
> > queue would help, though this one is more complex.
> 
> The patch we're replying to adds callbacks (to read rip, etc.), so it's
> no big deal.  For the queue solution, a queue of size one would probably
> be sufficient even if not guaranteed by the spec.  I don't see how the
> cpu can do another guest entry without delivering the NMI.
> 
> > But I am still curious if we extend the region, how much it would help.
> > Would get a result soon...
> 
> Yes, interesting to see what the latency is.  If it's reasonably short
> (and I expect it will be so), we can do the busy wait solution.
> 
> If we have an NMI counter somewhere, we can simply wait until it changes.
 
Good idea. Of course we have one(at least on x86). There is 
irq_stat.irq__nmi_count for per cpu. :)

-- 
regards
Yang, Sheng
