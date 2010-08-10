Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab0HJRZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 13:25:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61120 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab0HJRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 13:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gkHRyt+hOsM1tZtffreVWfMBs6qwMzKsPnMZKoXzt5xoaQKG1VMVe/En6N7HznT7Pd
         irXS/Oi7JEi4L/Mo9aQ6dp7XCOn1ZWo2Isq2YrDs9fOUAvPKDw0oqaZ2ncztE+EZr7nd
         q+oX0ZmpIHuHav9OIEnTbkUUEswyc1bppi9bo=
Date: Tue, 10 Aug 2010 21:24:51 +0400
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
Message-ID: <20100810172451.GD6893@lenovo>
References: <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100809200245.GF6056@lenovo> <20100810074200.GE26154@erda.amd.com> <20100810161627.GB6893@lenovo> <20100810164124.GK26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810164124.GK26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 06:41:24PM +0200, Robert Richter wrote:
> On 10.08.10 12:16:27, Cyrill Gorcunov wrote:
> > On Tue, Aug 10, 2010 at 09:42:00AM +0200, Robert Richter wrote:
> > > On 09.08.10 16:02:45, Cyrill Gorcunov wrote:
> > > 
> > > > > @@ -1222,14 +1245,12 @@ perf_event_nmi_handler(struct notifier_block *self,
> > > > >  	regs = args->regs;
> > > > >  
> > > > >  	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > > > 
> > > > If only I'm not missing something this apic_write should go up to
> > > > "case DIE_NMIUNKNOWN" site, no?
> > > 
> > > This seems to be code from the non-nmi implementation and can be
> > > removed at all, which should be a separate patch. The vector is
> > > already set up.
> > > 
> > > -Robert
> > >
> > 
> > No, this is just a short way to unmask LVTPC (which is required for
> > cpus). Actually lookig into this snippet I found that in p4 pmu
> > I've made one redundant unmaksing operation. will update as only
> > this area settle down.
> 
> The vector is setup in hw_perf_enable() and then never masked. The
> perfctrs nmi is alwayes enabled since then. I still see no reason for
> unmasking it again with every nmi. Once you handle the nmi it is also
> enabled.
> 

It gets masked on NMI arrival, at least for some models (Core Duo, P4,
P6 M and I suspect more theh that, that was the reason oprofile has
it, also there is a note in SDM V3a page 643).

> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 
	-- Cyrill
