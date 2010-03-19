Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab0CSR3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 13:29:08 -0400
Received: from 8bytes.org ([88.198.83.132]:57011 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab0CSR3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 13:29:07 -0400
Date: Fri, 19 Mar 2010 18:29:03 +0100
From: oerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
	host side
Message-ID: <20100319172903.GI13108@8bytes.org>
References: <1268717232.2813.36.camel@localhost> <1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319082122.GE12576@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 09:21:22AM +0100, Ingo Molnar wrote:
> Unfortunately, in a previous thread the Qemu maintainer has indicated that he 
> will essentially NAK any attempt to enhance Qemu to provide an easily 
> discoverable, self-contained, transparent guest mount on the host side.
> 
> No technical justification was given for that NAK, despite my repeated 
> requests to particulate the exact security problems that such an approach 
> would cause.
> 
> If that NAK does not stand in that form then i'd like to know about it - it 
> makes no sense for us to try to code up a solution against a standing 
> maintainer NAK ...

I still think it is the best and most generic way to let the guest do
the symbol resolution. This has several advantages:

	1. The guest knows best about its symbol space. So this would be
	   extensible to other guest operating systems.  A brave
	   developer may even implement symbol passing for Windows or
	   the BSDs ;-)

	2. The guest can decide for its own if it want to pass this
	   inforamtion to the host-perf. No security issues at all.

	3. The guest can also pass us the call-chain and we don't need
	   to care about complicated of fetching from the guest
	   ourself.

	4. This way extensible to nested virtualization too.

How we speak to the guest was already discussed in this thread. My
personal opinion is that going through qemu is an unnecessary step and
we can solve that more clever and transparent for perf.

	Joerg

