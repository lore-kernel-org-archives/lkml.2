Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3AHTqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 14:46:39 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:61931 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab3AHTqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 14:46:38 -0500
Date: Tue, 8 Jan 2013 14:46:34 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v5 00/12] x86/microcode: Early load microcode
Message-ID: <20130108194633.GA15194@phenom.dumpdata.com>
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
 <20130103174455.GA7350@localhost.localdomain>
 <50E5C47B.6060707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E5C47B.6060707@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 09:48:43AM -0800, H. Peter Anvin wrote:
> On 01/03/2013 09:44 AM, Konrad Rzeszutek Wilk wrote:
> >
> >A couple of questions - why the usage of native_[read|write]_msr? I get the
> >__native_cpuid variant, but I am not sure I understand why you are using
> >the native_* variants. Especially as this code ends up being called on
> >Xen and lguest (at least on 64-bit) and probably should go through the
> >paravirt interfaces.
> >
> 
> For Xen, the early microcode update should be done in the hypervisor launch.

Right. That is the plan.
> 
> However, if you have a more specific flow in mind please clarify.

> Keep in mind Xen is largely a black box to non-Xen developers
> (#include <stdrant.h>).

OK. I am trying to figure out whether this usage of native_* for the
MSRs was done on purpose - and it sounds like the answer is no. If so -
can it be done using the normal 'safe_rdmsr' and 'wrmsr'?

That would allow at least in the case of Xen, to omit a whole bunch
of MSR writes/reads during the boot that are not neccessary as we would
not trap in the hypervisor - but could use the pvops version of
read/write MSR calls to just do a nop.

> 
> 	-hpa
> 
> P.S. Since when is lguest 64-bit?  Did I miss something?

Oh, I assumed it could do it.
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
