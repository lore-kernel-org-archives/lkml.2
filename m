Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1G0GVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:21:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54555 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1G0GVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:21:36 -0400
Date: Wed, 27 Jul 2011 08:21:20 +0200
From: Borislav Petkov <bp@amd64.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Przywara, Andre" <Andre.Przywara@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110727062120.GA5272@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <4E2F0068.1080001@redhat.com>
 <20110726181304.GD32536@aftab>
 <4E2F0498.8050005@zytor.com>
 <20110726183721.GF32536@aftab>
 <4E2F09BB.9060605@zytor.com>
 <4E2F1889.8030708@amd.com>
 <4E2F90A2.4030409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2F90A2.4030409@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:14:26AM -0400, Avi Kivity wrote:
> On 07/26/2011 10:42 PM, Andre Przywara wrote:
> >
> > There is no need to determine it by calculating, because it caused by 
> > the special design of the BD L1 cache and thus fixed.
> > And a calculation would be even more confusing:
> >
> > The L1I is virtually indexed, but physically tagged.
> > 64KB L1I cache, 64 Bytes per Cacheline = 1024 cache lines
> > 1024 lines / 2 way associative = 512 indexes
> > 64 Bytes per Cacheline (6 bits) + 512 indexes (9 bits) = bits [14:0]
> > virtual and physical addresses are the same for bits [11:0], which 
> > leaves the remaining 14:12 susceptible for aliasing.
> >
> > So bit 12 comes from PAGESIZE and yes, the 14 could be derived from 
> > the CPUID cache info, but I don't see much value in breaking this down 
> > this way.
> > But I agree that there should be some comment in the patch which at 
> > least notes that bits [14:12] are due to the L1I design, maybe we can 
> > copy a nicer version of the above math in the commit message for 
> > reference.
> >
> 
> If among the 12,432.8 cpuid leaves exposed by the cpu we had a bit that 
> said L1I was shared, and another that said it was virtually indexed, and 
> others describing the cache size, cache line size, and number of ways, 
> then we could perform the arithmetic at runtime, yes?
> 
> That means that if the caches grow or increase their associativity, then 
> we don't need to patch the kernel again.

Yeah, actually the idea is to patch the kernel only this one time and
never ever be needing to do this for future CPUs, for this matter.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
