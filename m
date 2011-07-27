Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1G0Phr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:37:47 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37164 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1G0Phq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:37:46 -0400
Date: Wed, 27 Jul 2011 17:37:31 +0200
From: Borislav Petkov <bp@amd64.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110727153731.GA19477@aftab>
References: <4E2F0068.1080001@redhat.com>
 <20110726181304.GD32536@aftab>
 <4E2F0498.8050005@zytor.com>
 <20110726183721.GF32536@aftab>
 <4E2F09BB.9060605@zytor.com>
 <4E2F1889.8030708@amd.com>
 <4E2F90A2.4030409@redhat.com>
 <20110727062120.GA5272@aftab>
 <20110727065932.GA16555@elte.hu>
 <4E2FDAD0.8000809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2FDAD0.8000809@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 05:30:56AM -0400, Avi Kivity wrote:
> On 07/27/2011 09:59 AM, Ingo Molnar wrote:
> > >
> > >  Yeah, actually the idea is to patch the kernel only this one time
> > >  and never ever be needing to do this for future CPUs, for this
> > >  matter.
> >
> > But the check you have added turns this workaround on for all family
> > 0x15 CPUs. If a family 0x15 CPU is built with a larger or more
> > associative cache, one that does not need the workaround, we would
> > still turn on the workaround.
> 
> Similarly, if family 0x21 CPUs have a similar arrangement (with 
> identical or different cache sizes and associativity) the hardcoded 
> check will fail.

So, in short, I$ design is the same for all F15h processors so a family
0x15 check suffices here.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
