Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab0HJQQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:16:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62665 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab0HJQQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZUzKr7XWBpz98QD3tm7HX8RiBB/a1OveKuJYsyrym+HuoUs3nTgeqGEldlXTwvvMF2
         HZ50kE25GcBB4IYAZj+sJsAcb5c5NePj+3PfQdvJUjYCL4OAmgy26RSQI8I3Wi4EHgM5
         XxSPa/fbYX3Zz0qk2YDFlJ1dGdzDpB236a/uA=
Date: Tue, 10 Aug 2010 20:16:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100810161627.GB6893@lenovo>
References: <20100804161046.GC5130@lenovo> <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100809200245.GF6056@lenovo> <20100810074200.GE26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810074200.GE26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 09:42:00AM +0200, Robert Richter wrote:
> On 09.08.10 16:02:45, Cyrill Gorcunov wrote:
> 
> > > @@ -1222,14 +1245,12 @@ perf_event_nmi_handler(struct notifier_block *self,
> > >  	regs = args->regs;
> > >  
> > >  	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > 
> > If only I'm not missing something this apic_write should go up to
> > "case DIE_NMIUNKNOWN" site, no?
> 
> This seems to be code from the non-nmi implementation and can be
> removed at all, which should be a separate patch. The vector is
> already set up.
> 
> -Robert
>

No, this is just a short way to unmask LVTPC (which is required for
cpus). Actually lookig into this snippet I found that in p4 pmu
I've made one redundant unmaksing operation. will update as only
this area settle down.

	-- Cyrill
