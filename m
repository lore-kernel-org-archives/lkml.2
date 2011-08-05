Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1HECZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 22:25:09 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:28627
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411Ab1HECZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 22:25:06 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:160.36.179.135;KIP:(null);UIP:(null);IPVD:NLI;H:kedge3.utk.tennessee.edu;RD:kedge3.utk.tennessee.edu;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 4 Aug 2011 22:24:58 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [perf] enable raw OFFCORE_EVENTS for non-perf userspace
In-Reply-To: <1312473330.16729.42.camel@twins>
Message-ID: <alpine.DEB.2.00.1108042221450.3022@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu> <1312473330.16729.42.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginatorOrg: utk.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Aug 2011, Peter Zijlstra wrote:

> On Wed, 2011-08-03 at 12:05 -0400, Vince Weaver wrote:
> 
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 4ee3abf..28f9ca9 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -604,12 +604,8 @@ static int x86_setup_perfctr(struct perf_event *event)
> >  			return -EOPNOTSUPP;
> >  	}
> >  
> > -	/*
> > -	 * Do not allow config1 (extended registers) to propagate,
> > -	 * there's no sane user-space generalization yet:
> > -	 */
> >  	if (attr->type == PERF_TYPE_RAW)
> > -		return 0;
> > +		return x86_pmu_extra_regs(event->attr.config, event);
> >  
> >  	if (attr->type == PERF_TYPE_HW_CACHE)
> >  		return set_ext_hw_attr(hwc, event);
> 
> 
> I'm inclined to merge this, aside from snb, the offcore stuff is
> actually quite usable now. Ingo can we somehow persuade you?

This would make me happy.  The patch is more or less a revert of the patch 
that disabled support in the first place, but if you need my signed-off-by 
(I forgot it before) here it is

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>

> Anybody who knows how to program the snb offcore please tell. I mean we
> have all the code to poke at the right registers, and the SDM lists all
> the various bits that go where and a few constraints on how to combine
> said bits, but I've really no idea what any of it means.

I've added Stephane as I think he did some work on SandyBridge offcore.

Vince

