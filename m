Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab1ATNlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 08:41:36 -0500
Received: from canuck.infradead.org ([134.117.69.58]:53170 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab1ATNle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:41:34 -0500
Subject: Re: [PATCH 2/3] kvm hypervisor : Add hypercalls to support
 pv-ticketlock
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@linux.vnet.ibm.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
In-Reply-To: <20110120115958.GB11177@linux.vnet.ibm.com>
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
	 <20110119164432.GA30669@linux.vnet.ibm.com>
	 <20110119171239.GB726@linux.vnet.ibm.com>
	 <1295457672.28776.144.camel@laptop> <4D373340.60608@goop.org>
	 <20110120115958.GB11177@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 Jan 2011 14:41:46 +0100
Message-ID: <1295530906.28776.171.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 17:29 +0530, Srivatsa Vaddagiri wrote:
> 
> If we had a yield-to [1] sort of interface _and_ information on which vcpu
> owns a lock, then lock-spinners can yield-to the owning vcpu, 

and then I'd nak it for being stupid ;-)

really, yield*() is retarded, never even consider using it. If you've
got the actual owner you can do full blown PI, which is tons better than
a 'do-something-random' call.

The only reason the whole non-virt pause loop filtering muck uses it is
because it really doesn't know anything, and do-something is pretty much
all it can do. Its a broken interface.
