Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab0I0PQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:16:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab0I0PQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:16:29 -0400
Date: Mon, 27 Sep 2010 11:16:07 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
Message-ID: <20100927151607.GX26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-7-git-send-email-ying.huang@intel.com>
 <20100927104426.GD32222@erda.amd.com>
 <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
 <20100927134341.GQ13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100927134341.GQ13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 03:43:41PM +0200, Robert Richter wrote:
> On 27.09.10 08:56:44, huang ying wrote:
> 
> > >> -static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
> > >> -{
> > >> -     unsigned char reason = get_nmi_reason();
> > >> -     char buf[64];
> > >> -
> > >> -     sprintf(buf, "NMI received for unknown reason %02x\n", reason);
> > >> -     die_nmi(buf, regs, 1); /* Always panic here */
> > >> -     return 0;
> > >
> > > You are dropping this code that is different to panic().
> > 
> > What is the difference? Is it relevant?
> 
> I think yes, since the code behaves different. Otherwise we could
> remove die_nmi() completly and replace it by panic(). But both are
> different implementions. Maybe we can merge the code, but I didn't
> look at it closly.

Actually die_nmi is a wrapper around panic with two important pieces.
One, it dumps some registers and two it does another notifier call to
DIE_NMIWATCHDOG (which correlates to another discussion in this patch
series).

So if we do any consolidation between panic and die_nmi, it should be
convert to die_nmi.  But then I wonder if that breaks the original
semantics of 'panic_on_unrecovered_nmi'.  I don't think so though.

Cheers,
Don
