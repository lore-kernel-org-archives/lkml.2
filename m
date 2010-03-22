Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab0CVLrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:47:46 -0400
Received: from 8bytes.org ([88.198.83.132]:36133 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab0CVLrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:47:45 -0400
Date: Mon, 22 Mar 2010 12:47:44 +0100
From: Joerg Roedel <joro@8bytes.org>
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
Message-ID: <20100322114744.GC1940@8bytes.org>
References: <1268717232.2813.36.camel@localhost> <1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu> <20100319172903.GI13108@8bytes.org> <20100321184300.GB25922@elte.hu> <20100322101451.GK13108@8bytes.org> <20100322105927.GB3483@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322105927.GB3483@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 11:59:27AM +0100, Ingo Molnar wrote:
> Best would be if you demonstrated any problems of the perf symbol lookup code 
> you are aware of on the host side, as it has that exact design you are 
> criticising here. We are eager to fix any bugs in it.
> 
> If you claim that it's buggy then that should very much be demonstratable - no 
> need to go into theoretical arguments about it.

I am not claiming anything. I just try to imagine how your proposal
will look like in practice and forgot that symbol resolution is done at
a later point.
But even with defered symbol resolution we need more information from
the guest than just the rip falling out of KVM. The guest needs to tell
us about the process where the event happened (information that the host
has about itself without any hassle) and which executable-files it was
loaded from.

> > Avi was against that but I think it would make sense to give names to 
> > virtual machines (with a default, similar to network interface names). Then 
> > we can create a directory in /dev/ with that name (e.g. /dev/vm/fedora/). 
> > Inside the guest a (priviledged) process can create some kind of named 
> > virt-pipe which results in a device file created in the guests directory 
> > (perf could create /dev/vm/fedora/perf for example). This file is used for 
> > guest-host communication.
> 
> That is kind of half of my suggestion - the built-in enumeration guests and a 
> guaranteed channel to them accessible to tools. (KVM already has its own 
> special channel so it's not like channels of communication are useless.)
> 
> The other half of my suggestion is that if we bring this thought to its 
> logical conclusion then we might as well walk the whole mile and not use 
> quirky, binary API single-channel pipes. I.e. we could use this convenient, 
> human-readable, structured, hierarchical abstraction to expose information in 
> a finegrained, scalable way, which has a world-class implementation in Linux: 
> the 'VFS namespace'.

Probably. At least it is the solution that fits best into the current
design of perf. But we should think about how this will be done. Raw
disk access is no solution because we need to access virtual
file-systems of the guest too. Network filesystems may be a solution but
then we come back to the 'deployment-nightmare'.

	Joerg

