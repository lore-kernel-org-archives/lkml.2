Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0CROkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:40:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0CROkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:40:17 -0400
Date: Thu, 18 Mar 2010 11:40:08 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, zhiteng.huang@intel.com,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 3/3] perf events: Change perf parameter --pid to
 process-wide collection instead of thread-wide
Message-ID: <20100318144008.GB2873@ghostprotocols.net>
References: <1268904666.2813.172.camel@localhost>
 <20100318133548.GA2873@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318133548.GA2873@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 18, 2010 at 10:35:48AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Mar 18, 2010 at 05:31:06PM +0800, Zhang, Yanmin escreveu:
> > From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > 
> > Parameter --pid (or -p) of perf currently means a thread-wide collection.
> > For exmaple, if a process whose id is 8888 has 10 threads, 'perf top -p 8888'
> > just collects the main thread statistics. That's misleading. Users are
> > used to attach a whole process when debugging a process by gdb. To follow
> > normal usage style, the patch change --pid to process-wide collection and
> > add --tid (-t) to mean a thread-wide collection.
> > 
> > Usage example is:
> > #perf top -p 8888
> > #perf record -p 8888 -f sleep 10
> > #perf stat -p 8888 -f sleep 10
> > Above commands collect the statistics of all threads of process 8888.
> > 
> > Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> 
> Just did visual inspection of the three patches, all sane, except for
> some coding style nits, don't worry right now for that, I'll fix them up

Nah, didn't fix them up, left it for some followup patch to avoid
risking introducing problems, applied as is, did some testing and pushed
to Ingo, thanks!

> myself, but please take those into account int the future, highlight
> below.

- Arnaldo
