Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0CXL7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:59:06 -0400
Received: from 8bytes.org ([88.198.83.132]:43218 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab0CXL7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:59:04 -0400
Date: Wed, 24 Mar 2010 12:59:01 +0100
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
Message-ID: <20100324115900.GB14800@8bytes.org>
References: <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA99BCB.5080501@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 06:57:47AM +0200, Avi Kivity wrote:
> On 03/23/2010 08:21 PM, Joerg Roedel wrote:
>> This enumeration is a very small and non-intrusive feature. Making it
>> aware of namespaces is easy too.
>>    
>
> It's easier (and safer and all the other boring bits) not to do it at  
> all in the kernel.

For the KVM stack is doesn't matter where it is implemented. It is as
easy in qemu or libvirt as in the kernel. I also don't see big risks. On
the perf side and for its users it is a lot easier to have this in the
kernel.
I for example always use plain qemu when running kvm guests and never
used libvirt. The only central entity I have here is the kvm kernel
modules. I don't want to start using it only to be able to use perf kvm.

>> Who would be the consumer of such notifications? A 'perf kvm list' can
>> live without I guess. If we need them later we can still add them.
>
> System-wide monitoring needs to work equally well for guests started  
> before or after the monitor.

Could be easily done using notifier chains already in the kernel.
Probably implemented with much less than 100 lines of additional code.

> Even disregarding that, if you introduce  an API, people will start
> using it and complaining if it's incomplete.

There is nothing wrong with that. We only need to define what this API
should be used for to prevent rank growth. It could be an
instrumentation-only API for example.

>> My statement was not limited to enumeration, I should have been more
>> clear about that. The guest filesystem access-channel is another
>> affected part. The 'perf kvm top' command will access the guest
>> filesystem regularly and going over qemu would be more overhead here.
>>    
>
> Why?  Also, the real cost would be accessing the filesystem, not copying  
> data over qemu.

When measuring cache-misses any additional (and in this case
unnecessary) copy-overhead result in less appropriate results.

>> Providing this in the KVM module directly also has the benefit that it
>> would work out-of-the-box with different userspaces too.  Or do we want
>> to limit 'perf kvm' to the libvirt-qemu-kvm software stack?
>
> Other userspaces can also provide this functionality, like they have to  
> provide disk, network, and display emulation.  The kernel is not a huge  
> library.

This has nothing to do with a library. It is about entity and resource
management which is what os kernels are about. The virtual machine is
the entity (similar to a process) and we want to add additional access
channels and names to it.

        Joerg

