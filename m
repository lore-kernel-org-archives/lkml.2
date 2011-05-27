Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab1E0KFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 06:05:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52204 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260Ab1E0KFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 06:05:23 -0400
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when
 CONFIG_ALIGNMENT_TRAP
From: Will Deacon <will.deacon@arm.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org
In-Reply-To: <4DDEC1C0.20807@linux.intel.com>
References: <20110523111648.10474.78396.stgit@e102109-lin.cambridge.arm.com>
	 <20110523132124.GI17672@n2100.arm.linux.org.uk>
	 <1306229953.19557.14.camel@e102109-lin.cambridge.arm.com>
	 <yw1xipt0p4i9.fsf@unicorn.mansr.com>
	 <BANLkTi=xLE9gP5YOdr9dR0DfsY1Ymzxu+w@mail.gmail.com>
	 <20110524171331.GA2941@arm.com>
	 <20110525111405.GA12010@e102109-lin.cambridge.arm.com>
	 <20110525124348.GA2340@arm.com> <yw1xaaeanbxe.fsf@unicorn.mansr.com>
	 <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com>
	 <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
	 <alpine.LFD.2.00.1105261650330.3207@xanadu.home>
	 <4DDEC1C0.20807@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 11:05:09 +0100
Message-ID: <1306490709.26257.4.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Thu, 2011-05-26 at 22:10 +0100, Andi Kleen wrote:
> 
> > It is possible that -fconserve-stack is still valuable on ARM given that
> > it is also used with -mno-unaligned-access for other things than
> > structure packing on the stack, and therefore its merits can be debated
> > independently from the alignment issue at hand.
> 
> The big advantage of -fconserve-stack is that it throttles the inliner
> if the inlining
> would cause too much stack growth. This is something you likely want
> on ARM too, especially as code gets more and more complex.

Do you have any concrete examples of -fconserve-stack giving an overall
win that isn't in the noise? The fact that the GCC documentation
explicitly states that enabling the option can lead to `making the
program slower' does make me question why we're enabling it in the first
place.

>From private conversation, the GCC guys don't seem to think this is a
bug so I'm reluctant to open a bugzilla ticket.

Will

