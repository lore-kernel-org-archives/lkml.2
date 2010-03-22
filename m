Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab0CVKOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:14:54 -0400
Received: from 8bytes.org ([88.198.83.132]:51265 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab0CVKOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:14:52 -0400
Date: Mon, 22 Mar 2010 11:14:51 +0100
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
Message-ID: <20100322101451.GK13108@8bytes.org>
References: <1268717232.2813.36.camel@localhost> <1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu> <20100319172903.GI13108@8bytes.org> <20100321184300.GB25922@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100321184300.GB25922@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 07:43:00PM +0100, Ingo Molnar wrote:
> Having access to the actual executable files that include the symbols achieves 
> precisely that - with the additional robustness that all this functionality is 
> concentrated into the host, while the guest side is kept minimal (and 
> transparent).

If you want to access the guests file-system you need a piece of
software running in the guest which gives you this access. But when you
get an event this piece of software may not be runnable (if the guest is
in an interrupt handler or any other non-preemptible code path). When the
host finally gets access to the guests filesystem again the source of
that event may already be gone (process has exited, module unloaded...).
The only way to solve that is to pass the event information to the guest
immediatly and let it collect the information we want.


> It can decide whether it exposes the files. Nor are there any "security 
> issues" to begin with.

I am not talking about security. Security was sufficiently flamed about
already.

> You need to be aware of the fact that symbol resolution is a separate step 
> from call chain generation.

Same concern as above applies to call-chain generation too.

> > How we speak to the guest was already discussed in this thread. My personal 
> > opinion is that going through qemu is an unnecessary step and we can solve 
> > that more clever and transparent for perf.
> 
> Meaning exactly what?

Avi was against that but I think it would make sense to give names to
virtual machines (with a default, similar to network interface names).
Then we can create a directory in /dev/ with that name (e.g.
/dev/vm/fedora/). Inside the guest a (priviledged) process can create
some kind of named virt-pipe which results in a device file created in
the guests directory (perf could create /dev/vm/fedora/perf for
example). This file is used for guest-host communication.

Thanks,

	Joerg

