Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab1EZW3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:29:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:45856 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758599Ab1EZW3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:29:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,276,1304319600"; 
   d="scan'208";a="5575812"
Message-ID: <4DDED44E.9070402@linux.intel.com>
Date: Thu, 26 May 2011 15:29:34 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@fluxnic.net>, Will Deacon <will.deacon@arm.com>,
        =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when	CONFIG_ALIGNMENT_TRAP
References: <1306229953.19557.14.camel@e102109-lin.cambridge.arm.com> <yw1xipt0p4i9.fsf@unicorn.mansr.com> <BANLkTi=xLE9gP5YOdr9dR0DfsY1Ymzxu+w@mail.gmail.com> <20110524171331.GA2941@arm.com> <20110525111405.GA12010@e102109-lin.cambridge.arm.com> <20110525124348.GA2340@arm.com> <yw1xaaeanbxe.fsf@unicorn.mansr.com> <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com> <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com> <alpine.LFD.2.00.1105261650330.3207@xanadu.home> <20110526215101.GL24876@n2100.arm.linux.org.uk>
In-Reply-To: <20110526215101.GL24876@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Catalin said in his mail "I haven't tried with -mno-unaligned-access, I
> suspect the variables on the stack would be aligned.".  So I don't think
> we know enough to say whether -mno-unaligned-access avoids the stack
> packing.

It won't, the arm gcc code just checks flag_conserve_stack.
IMHO it's just a gcc bug. You should report it to 
http://gcc.gnu.org/bugzilla

As a temporary workaround you can disable it in the kernel too, but as soon
as the compiler it's fixed I would recommend considering to reenable it.

-Andi

