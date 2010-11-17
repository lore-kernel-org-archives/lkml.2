Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078Ab0KQRet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:34:49 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36564 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758221Ab0KQRes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:34:48 -0500
Subject: Re: [PATCH v2 05/20] ARM: LPAE: Introduce L_PTE_NOEXEC and
 L_PTE_NOWRITE
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101117173248.GG5308@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	 <1289584840-18097-6-git-send-email-catalin.marinas@arm.com>
	 <20101115183014.GD31421@n2100.arm.linux.org.uk>
	 <AANLkTik5FcZ3rNtiwN8kYP0LZh+YqGtKP_RteoFiWa16@mail.gmail.com>
	 <20101117171613.GB5308@n2100.arm.linux.org.uk>
	 <AANLkTincmfqXmNQznd1fdSRYd4Vc+p47cgTfEwQoXdFm@mail.gmail.com>
	 <20101117172425.GE5308@n2100.arm.linux.org.uk>
	 <1290015033.2351.69.camel@e102109-lin.cambridge.arm.com>
	 <20101117173248.GG5308@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 17 Nov 2010 17:34:42 +0000
Message-ID: <1290015282.2351.70.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2010 17:34:43.0148 (UTC) FILETIME=[B85010C0:01CB867D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 17:32 +0000, Russell King - ARM Linux wrote:
> On Wed, Nov 17, 2010 at 05:30:33PM +0000, Catalin Marinas wrote:
> > On Wed, 2010-11-17 at 17:24 +0000, Russell King - ARM Linux wrote:
> > > On Wed, Nov 17, 2010 at 05:22:12PM +0000, Catalin Marinas wrote:
> > > > Ah, good point, that was the mask.
> > > >
> > > > So for dmacoherent we make sure that L_PTE_EXEC is cleared. I suspect
> > > > we should now make sure that L_PTE_NOEXEC is set. For the other two,
> > > > just leave them as they are.
> > >
> > > Already done:
> > >
> > >  #define pgprot_dmacoherent(prot) \
> > > -       __pgprot_modify(prot, L_PTE_MT_MASK|L_PTE_EXEC, L_PTE_MT_BUFFERABLE)
> > > +       __pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_BUFFERABLE|L_PTE_XN)
> > > ...
> > >  #define pgprot_dmacoherent(prot) \
> > > -       __pgprot_modify(prot, L_PTE_MT_MASK|L_PTE_EXEC, L_PTE_MT_UNCACHED)
> > > +       __pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_UNCACHED|L_PTE_XN)
> >
> > Are you already doing such changes? Just to avoid duplicating effort
> > (and use common naming scheme).
> 
> I did say that I had patches for all the issues I raised so far...  They're
> just in the process of being posted (if lists.infradead.org this time can
> cope with one patch every 20 secs...)

I wasn't sure which patches, so I did the XN/RDONLY as well (not big
patch though).

I'll rebase my LPAE stuff in the next days and repost.

Thanks.

-- 
Catalin

