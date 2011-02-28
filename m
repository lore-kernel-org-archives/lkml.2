Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1B1SiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:38:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab1B1SiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:38:15 -0500
Date: Mon, 28 Feb 2011 13:37:59 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
Message-ID: <20110228183759.GD11359@redhat.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
 <1294348732-15030-6-git-send-email-dzickus@redhat.com>
 <alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>
 <4D68B397.6040809@gmail.com>
 <AANLkTi==WbHfLrWAjFCZU9VAhfyf9MLnvKza=i9PuO7r@mail.gmail.com>
 <4D68F346.1000500@gmail.com>
 <AANLkTin3nY6++whgOGTC=HLN_oK0J5chsx5uZ_OG6h8G@mail.gmail.com>
 <4D6917C6.2050509@gmail.com>
 <AANLkTinRyzkt_PtbnM4pNUUd7gwXSMQsTOVS9otG7v6D@mail.gmail.com>
 <4D6A332F.3080603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6A332F.3080603@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 02:19:11PM +0300, Cyrill Gorcunov wrote:
> On 02/27/2011 04:01 AM, huang ying wrote:
> ...
> >>
> >>  Probably we should put question in another fashion, ie in the fasion of
> >>overall design -- who should be
> >>responsible for handling external nmis, 1) the cpu which apic is configured
> >>to observe such nmis or 2) any cpu?
> >>If we take 1) then no lock is needed and underlied code will report real cpu
> >>number who observed nmi. If
> >>we take 2) then lock is needed but we need a big comment in default_do_nmi
> >>together with probably cpu number
> >>fixed in serr\iochk printk's.
> >
> >I am OK with both solutions.
> >
> >Best Regards,
> >Huang Ying
> 
> ok, lets see what others think on this thread

I'm trying to figure out how this affects SGI's systems which currently
enable external NMIs to all cpu's in order to support their nmi button to
dump cpu stacks on a system hang
(arch/x86/kernel/apic/x2apic_uv_x.c::uv_nmi_init)

But feel free to post patches addressing your concerns as I am getting a
little lost in the all the concerns being thrown back and forth.

Cheers,
Don
