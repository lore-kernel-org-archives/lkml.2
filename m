Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab0CXNqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:46:45 -0400
Received: from 8bytes.org ([88.198.83.132]:48654 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab0CXNqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:46:43 -0400
Date: Wed, 24 Mar 2010 14:46:42 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100324134642.GD14800@8bytes.org>
References: <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com> <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA0DFE.1080700@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 03:05:02PM +0200, Avi Kivity wrote:
> On 03/24/2010 02:50 PM, Joerg Roedel wrote:

>> I don't want the tool for myself only. A typical perf user expects that
>> it works transparent.
>
> A typical kvm user uses libvirt, so we can integrate it with that.

Someone who uses libvirt and virt-manager by default is probably not
interested in this feature at the same level a kvm developer is. And
developers tend not to use libvirt for low-level kvm development.  A
number of developers have stated in this thread already that they would
appreciate a solution for guest enumeration that would not involve
libvirt.

> Someone needs to know about the new guest to fetch its symbols.  Or do  
> you want that part in the kernel too?

The samples will be tagged with the guest-name (and some additional
information perf needs). Perf userspace can access the symbols then
through /sys/kvm/guest0/fs/...

>> Depends on how it is designed. A filesystem approach was already
>> mentioned. We could create /sys/kvm/ for example to expose information
>> about virtual machines to userspace. This would not require any new
>> security hooks.
>
> Who would set the security context on those files?

An approach like: "The files are owned and only readable by the same
user that started the vm." might be a good start. So a user can measure
its own guests and root can measure all of them.

> Plus, we need cgroup  support so you can't see one container's guests
> from an unrelated container.

cgroup support is an issue but we can solve that too. Its in general
still less complex than going through the whole libvirt-qemu-kvm stack.

> Integration with qemu would allow perf to tell us that the guest is
> hitting the interrupt status register of a virtio-blk device in pci
> slot 5 (the information is already available through the kvm_mmio
> trace event, but  only qemu can decode it).

Yeah that would be interesting information. But it is more related to
tracing than to pmu measurements.
The information which you mentioned above are probably better
captured by an extension of trace-events to userspace.

	Joerg

