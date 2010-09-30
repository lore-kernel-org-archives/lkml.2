Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab0I3Egm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:36:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab0I3Egl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:36:41 -0400
Date: Thu, 30 Sep 2010 00:36:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
Message-ID: <20100930043628.GE26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-6-git-send-email-ying.huang@intel.com>
 <20100927100901.GC32222@erda.amd.com>
 <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
 <20100927133816.GP13563@erda.amd.com>
 <20100927152014.GY26290@redhat.com>
 <1285634172.20791.92.camel@yhuang-dev>
 <20100928153247.GL26290@redhat.com>
 <AANLkTinmhTgVhPsmGLC8Z-9Kx3xRovWy=9+R_5B4u6Cx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinmhTgVhPsmGLC8Z-9Kx3xRovWy=9+R_5B4u6Cx@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 04:17:30PM +0800, huang ying wrote:
> On Tue, Sep 28, 2010 at 11:32 PM, Don Zickus <dzickus@redhat.com> wrote:
> 
> > But the problem is you have to export all this platform specific stuff to
> > traps.c and surround the code with #ifdef's, which start to look ugly.
> 
> There is no #ifdef in my final default_do_nmi(), so I think the code
> can be cleaned up without converting everything into notifier block. I
> think the rule can be: architecture specific thing should go direct
> call, while device driver should be turned into notifier block.

That sounds like a good rule, but then my definition of architecture
specific is whatever is written in the intel/amd x86_64 architecture
manual (that sits on my desk, dated 2002), which wouldn't include any
of the error handling you propose, nor MCE, nor perf.

I guess I look at all that stuff as cpu features because not all the cpus
on the market have them.  Shouldn't traps.c just contain core architecture
stuff and all those hardware error features could go under
arch/x86/kernel/cpu with the rest of the features, no?

> 
> > Is there any reason why traps.c should know about MCA/HEST/<other hardware
> > errors>?  Shouldn't it be abstracted away?
> 
> Yes. The device drivers should be abstracted away, leaving
> architectural logic, such as port 0x61 as direct call. We need
> notifier chain, but I just suggest reduce its usage if possible.
> 
> > Honestly, I would be interested in creating a southbridge driver and
> > moving the port 0x61 code there and keeping the default_do_nmi() function
> > stupidly simple (just a call to the die_chain and the
> > unknown_nmi_error()).
> 
> I think the southbridge drivers should go notifier block, but the port
> 0x61 code is architectural and should be kept in default_do_nmi().

Is port 0x61 architectural?  I thought it a southbridge thing.  In fact I
thought with modern chipsets you can access the same thing through port
0x70 or 0x71 (I can't seem to figure out which Intel doc I saw that in).
(Not that this conversation has any bearing on your patchset, just an idea
I had).

Cheers,
Don
