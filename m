Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1E0QxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:53:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:64078 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab1E0QxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:53:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,281,1304319600"; 
   d="scan'208";a="5930386"
Message-ID: <4DDFD6F2.1040304@linux.intel.com>
Date: Fri, 27 May 2011 09:53:06 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when CONFIG_ALIGNMENT_TRAP
References: <20110523111648.10474.78396.stgit@e102109-lin.cambridge.arm.com>	 <20110523132124.GI17672@n2100.arm.linux.org.uk>	 <1306229953.19557.14.camel@e102109-lin.cambridge.arm.com>	 <yw1xipt0p4i9.fsf@unicorn.mansr.com>	 <BANLkTi=xLE9gP5YOdr9dR0DfsY1Ymzxu+w@mail.gmail.com>	 <20110524171331.GA2941@arm.com>	 <20110525111405.GA12010@e102109-lin.cambridge.arm.com>	 <20110525124348.GA2340@arm.com> <yw1xaaeanbxe.fsf@unicorn.mansr.com>	 <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com>	 <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>	 <alpine.LFD.2.00.1105261650330.3207@xanadu.home>	 <4DDEC1C0.20807@linux.intel.com> <1306490709.26257.4.camel@e102144-lin.cambridge.arm.com>
In-Reply-To: <1306490709.26257.4.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Do you have any concrete examples of -fconserve-stack giving an overall
> win that isn't in the noise? The fact that the GCC documentation
> explicitly states that enabling the option can lead to `making the
> program slower' does make me question why we're enabling it in the first
> place.

Because the kernel has a limited stack. We had a few cases in the past where
inlining blew it, especially in large ioctl switch() functions which inlined
lots of others.

On modern gccs it's better because it is smarter about sharing stack 
slots in large
functions. This was also worked around with manual noinlines.

But it's still far safer to tell gcc to conserve stack.

I consider the ARM gcc behaviour just a bug. The thing was really only 
intended
for the inliner (I asked for it originally)

-Andi

