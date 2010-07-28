Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0G1Saz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:30:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49052 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab0G1Saw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:30:52 -0400
Message-ID: <4C507728.3000207@zytor.com>
Date: Wed, 28 Jul 2010 11:30:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Ralph Campbell <infinipath@qlogic.com>
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>	 <1279822864-17154-32-git-send-email-yinghai@kernel.org>	 <1280295415.1970.245.camel@pasglop> <4C4FC95F.6040806@kernel.org>	 <4C4FD04B.5090503@zytor.com> <1280336548.30808.489.camel@mulgrave.site>	 <4C506E9B.4070501@zytor.com> <1280340633.30808.583.camel@mulgrave.site>
In-Reply-To: <1280340633.30808.583.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 11:10 AM, James Bottomley wrote:
> 
> So I don't understand the problem.  Proper shutdown of the old kernel
> will halt all the DMA engines (by design ... we can't have DMA ongoing
> if the next action might be power off).  The only case I know where DMA
> engines may be active is the crash kernel case.
> 

I'm not sure I fully understand the exact problem, either; not being
familiar with this putative "logging" facility of the Qlogic devices.
My point was largely that if a device causes failures because of the
choice of the allocation order, then we have a much bigger problem and
papering over it by trying to muck with the allocation order is just wrong.

This logging facility of Qlogic is DMA, no more, no less.  It needs to
be shut down on a "overwrite" kexec, where we replace one kernel with
another, as opposed to a crash dump kexec, where we use a reserved chunk
of virgin memory.  What I don't know/understand at the moment is if
there is something "special" about this particular logging facility,
e.g. if the Qlogic card ignore the bus mastering control bit -- which
would be reckless but I can see someone having the bright idea to do that.

Yinghai, do you have any more detail, or know who would?  Also copying
the Qlogic Infinipath maintainer email...

	-hpa
