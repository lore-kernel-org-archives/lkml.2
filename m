Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0HSRxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:53:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52148 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0HSRxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:53:51 -0400
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100819174331.GB8268@lenovo>
References: <20100804163930.GE5130@lenovo>
	 <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo>
	 <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com>
	 <20100809194829.GB26154@erda.amd.com> <20100817152225.GQ26154@erda.amd.com>
	 <1282214753.1926.4669.camel@laptop> <20100819141240.GO4879@redhat.com>
	 <1282228033.2605.204.camel@laptop>  <20100819174331.GB8268@lenovo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Aug 2010 19:53:37 +0200
Message-ID: <1282240417.2605.451.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 21:43 +0400, Cyrill Gorcunov wrote:
> > @@ -673,7 +673,7 @@ static int p4_pmu_handle_irq(struct pt_r
> >               if (!overflow && (val & (1ULL << (x86_pmu.cntval_bits
> - 1))))
> >                       continue;
> >  
> > -             handled += overflow;
> > +             handled += !!overflow;
> 
> No need to !! here, overflowed returns [0;1] though a small nit
> and could be updated later :) 

done.
