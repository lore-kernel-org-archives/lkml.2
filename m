Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1ATRtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:49:39 -0500
Received: from claw.goop.org ([74.207.240.146]:51432 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab1ATRth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:49:37 -0500
Message-ID: <4D3875AF.1000208@goop.org>
Date: Thu, 20 Jan 2011 09:49:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
Subject: Re: [PATCH 2/3] kvm hypervisor : Add hypercalls to support pv-ticketlock
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <20110119164432.GA30669@linux.vnet.ibm.com> <20110119171239.GB726@linux.vnet.ibm.com> <1295457672.28776.144.camel@laptop> <4D373340.60608@goop.org> <20110120114246.GA11177@linux.vnet.ibm.com>
In-Reply-To: <20110120114246.GA11177@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 03:42 AM, Srivatsa Vaddagiri wrote:
> On Wed, Jan 19, 2011 at 10:53:52AM -0800, Jeremy Fitzhardinge wrote:
>>> The reason for wanting this should be clear I guess, it allows PI.
>> Well, if we can expand the spinlock to include an owner, then all this
>> becomes moot...
> How so? Having an owner will not eliminate the need for pv-ticketlocks
> afaict. We still need a mechanism to reduce latency in scheduling the next
> thread-in-waiting, which is achieved by your patches. 

No, sorry, I should have been clearer.  I meant that going to the effort
of not increasing the lock size to record "in slowpath" state.

    J
