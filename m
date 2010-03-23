Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0CWSWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:22:06 -0400
Received: from 8bytes.org ([88.198.83.132]:47518 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab0CWSVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:21:55 -0400
Date: Tue, 23 Mar 2010 19:21:53 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100323182153.GA14800@8bytes.org>
References: <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA8EEDE.8070309@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 06:39:58PM +0200, Avi Kivity wrote:
> On 03/23/2010 04:06 PM, Joerg Roedel wrote:

>> And this system wide entity is the kvm module. It creates instances of
>> 'struct kvm' and destroys them. I see no problem if we just attach a
>> name to every instance with a good default value like kvm0, kvm1 ... or
>> guest0, guest1 ... User-space can override the name if it wants. The kvm
>> module takes care about the names being unique.
>>    
>
> So, two users can't have a guest named MyGuest each?  What about  
> namespace support?  There's a lot of work in virtualizing all kernel  
> namespaces, you're adding to that.

This enumeration is a very small and non-intrusive feature. Making it
aware of namespaces is easy too.

> What about notifications when guests  are added or removed?

Who would be the consumer of such notifications? A 'perf kvm list' can
live without I guess. If we need them later we can still add them.

>> This is very much the same as network card numbering is implemented in
>> the kernel.
>> Forcing perf to talk to qemu or even libvirt produces to much overhead
>> imho. Instrumentation only produces useful results with low overhead.
>>
>
> It's a setup cost only.

My statement was not limited to enumeration, I should have been more
clear about that. The guest filesystem access-channel is another
affected part. The 'perf kvm top' command will access the guest
filesystem regularly and going over qemu would be more overhead here.
Providing this in the KVM module directly also has the benefit that it
would work out-of-the-box with different userspaces too.  Or do we want
to limit 'perf kvm' to the libvirt-qemu-kvm software stack?

Sidenote: I really think we should come to a conclusion about the
          concept. KVM integration into perf is very useful feature to
	  analyze virtualization workloads.

Thanks,

	Joerg

