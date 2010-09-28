Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477Ab0I1Blr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:41:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:52798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab0I1Blq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,244,1283756400"; 
   d="scan'208";a="661752908"
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, huang ying <huang.ying.caritas@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100927165831.GT13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-7-git-send-email-ying.huang@intel.com>
	 <20100927104426.GD32222@erda.amd.com>
	 <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
	 <20100927134341.GQ13563@erda.amd.com> <20100927151607.GX26290@redhat.com>
	 <20100927165831.GT13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:41:43 +0800
Message-ID: <1285638103.20791.152.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 00:58 +0800, Robert Richter wrote:
> On 27.09.10 11:16:07, Don Zickus wrote:
> > On Mon, Sep 27, 2010 at 03:43:41PM +0200, Robert Richter wrote:
> > > On 27.09.10 08:56:44, huang ying wrote:
> > > 
> > > > >> -static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
> > > > >> -{
> > > > >> -     unsigned char reason = get_nmi_reason();
> > > > >> -     char buf[64];
> > > > >> -
> > > > >> -     sprintf(buf, "NMI received for unknown reason %02x\n", reason);
> > > > >> -     die_nmi(buf, regs, 1); /* Always panic here */
> > > > >> -     return 0;
> > > > >
> > > > > You are dropping this code that is different to panic().
> > > > 
> > > > What is the difference? Is it relevant?
> > > 
> > > I think yes, since the code behaves different. Otherwise we could
> > > remove die_nmi() completly and replace it by panic(). But both are
> > > different implementions. Maybe we can merge the code, but I didn't
> > > look at it closly.
> > 
> > Actually die_nmi is a wrapper around panic with two important pieces.
> > One, it dumps some registers and two it does another notifier call to
> > DIE_NMIWATCHDOG (which correlates to another discussion in this patch
> > series).
> > 
> > So if we do any consolidation between panic and die_nmi, it should be
> > convert to die_nmi.  But then I wonder if that breaks the original
> > semantics of 'panic_on_unrecovered_nmi'.  I don't think so though.
> 
> I agree, panic_on_unrecovered_nmi and unknown_nmi_panic almost do the
> same thing, though die_nmi() is specifically for nmi handlers. In the
> end we can consolidate both. We should then modify kernel.txt and
> route unknown_nmi_panic to panic_on_unrecovered_nmi or vice versa.

unknown_nmi_panic will cause panic for unknown NMI (can not identify the
NMI sources).

panic_on_unrecovered_nmi should panic for unrecovered hardware errors,
for known and unknown NMI. For example, panic_on_unrecovered_nmi will
cause panic in mem_parity_error too, which can be considered known NMI.

Is it reasonable?

Best Regards,
Huang Ying


