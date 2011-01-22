Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1AVOyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 09:54:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab1AVOyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:54:38 -0500
Message-ID: <4D3AEF7A.1050709@redhat.com>
Date: Sat, 22 Jan 2011 09:53:46 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?UTF-8?B?QW3DqXJpY28g?= =?UTF-8?B?V2FuZw==?= 
	<xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
Subject: Re: [PATCH 2/3] kvm hypervisor : Add hypercalls to support pv-ticketlock
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <20110119164432.GA30669@linux.vnet.ibm.com> <20110119171239.GB726@linux.vnet.ibm.com> <1295457672.28776.144.camel@laptop> <4D373340.60608@goop.org> <20110120115958.GB11177@linux.vnet.ibm.com> <4D38774B.6070704@goop.org> <20110121140208.GA13609@linux.vnet.ibm.com> <4D399CBD.10506@redhat.com> <20110122061417.GA7258@linux.vnet.ibm.com>
In-Reply-To: <20110122061417.GA7258@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2011 01:14 AM, Srivatsa Vaddagiri wrote:

> Also it may be possible for the pv-ticketlocks to track owning vcpu and make use
> of a yield-to interface as further optimization to avoid the
> "others-get-more-time" problem, but Peterz rightly pointed that PI would be a
> better solution there than yield-to. So overall IMO kvm_vcpu_on_spin+yield_to
> could be the best solution for unmodified guests, while paravirtualized
> ticketlocks + some sort of PI would be a better solution where we have the
> luxury of modifying guest sources!

Agreed, for unmodified guests (which is what people will mostly be
running for the next couple of years), we have little choice but
to use PLE + kvm_vcpu_on_spin + yield_to.

The main question that remains is whether the PV ticketlocks are
a large enough improvement to also merge those.  I expect they
will be, and we'll see so in the benchmark numbers.

-- 
All rights reversed
