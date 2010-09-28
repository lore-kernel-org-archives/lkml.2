Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0I1PVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:21:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085Ab0I1PVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:21:50 -0400
Date: Tue, 28 Sep 2010 11:21:35 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Robert Richter <robert.richter@amd.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
Message-ID: <20100928152135.GK26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-7-git-send-email-ying.huang@intel.com>
 <20100927104426.GD32222@erda.amd.com>
 <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
 <20100927134341.GQ13563@erda.amd.com>
 <20100927151607.GX26290@redhat.com>
 <20100927165831.GT13563@erda.amd.com>
 <1285638103.20791.152.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285638103.20791.152.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 09:41:43AM +0800, Huang Ying wrote:
> On Tue, 2010-09-28 at 00:58 +0800, Robert Richter wrote:
> > On 27.09.10 11:16:07, Don Zickus wrote:
> > > Actually die_nmi is a wrapper around panic with two important pieces.
> > > One, it dumps some registers and two it does another notifier call to
> > > DIE_NMIWATCHDOG (which correlates to another discussion in this patch
> > > series).
> > > 
> > > So if we do any consolidation between panic and die_nmi, it should be
> > > convert to die_nmi.  But then I wonder if that breaks the original
> > > semantics of 'panic_on_unrecovered_nmi'.  I don't think so though.
> > 
> > I agree, panic_on_unrecovered_nmi and unknown_nmi_panic almost do the
> > same thing, though die_nmi() is specifically for nmi handlers. In the
> > end we can consolidate both. We should then modify kernel.txt and
> > route unknown_nmi_panic to panic_on_unrecovered_nmi or vice versa.
> 
> unknown_nmi_panic will cause panic for unknown NMI (can not identify the
> NMI sources).
> 
> panic_on_unrecovered_nmi should panic for unrecovered hardware errors,
> for known and unknown NMI. For example, panic_on_unrecovered_nmi will
> cause panic in mem_parity_error too, which can be considered known NMI.
> 
> Is it reasonable?

Routing unknown_nmi_panic to panic_on_unrecovered_nmi makes sense to me,
just more difficult to type out. :-)

Cheers,
Don
