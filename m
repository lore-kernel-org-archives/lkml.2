Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2LSXVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:21:48 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:57058
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195Ab2LSXVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:21:41 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zz98dI1432Izz1de0h1202h1e76h1d1ah1d2ahz70kzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MFAWVZ-01-73L-02
X-M-MSG: 
Date: Wed, 19 Dec 2012 17:21:34 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Message-ID: <20121219232134.GA4816@jshin-Toonie>
References: <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
 <50CCF6F6.4020107@zytor.com>
 <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
 <50CD04F1.8020902@zytor.com>
 <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
 <20121219220504.GA32212@jshin-Toonie>
 <50D23EE8.7030904@zytor.com>
 <20121219225155.GK24895@liondog.tnic>
 <20121219225941.GB2968@jshin-Toonie>
 <20121219230329.GM24895@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121219230329.GM24895@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 12:03:29AM +0100, Borislav Petkov wrote:
> On Wed, Dec 19, 2012 at 04:59:41PM -0600, Jacob Shin wrote:
> > I can check but right, they might be used up. But even if we had slots
> > available, the memory range that needs to be covered is in large
> > enough address and aligned in such a way that you cannot cover it with
> > variable range MTRRs.
> 
> Actually, if I'm not mistaken, you only need to cover the HT hole with
> one MTRR - the rest remains WB. And in order the mask bits to work, we
> could make it a little bigger - we waste some memory but that's nothing
> in comparison to the MCE.

Actually all memory hole above 4GB and under TOM2 needs to be marked
as UC, if the kernel just blanket calls init_memory_mapping from 4GB
to top of memory.

Right we would be loosing memory, and I think depending on the
alignment of the boundary and how many MTRRs you have avaiable to use,
significant chunks of memory could be lost. I need to go refresh on
how variable range MTRRs are programmed, it has been a while.

> 
> You might need to talk to hw guys about the feasibility of this deal
> though.
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

