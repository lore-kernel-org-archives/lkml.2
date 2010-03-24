Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab0CXNxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:53:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab0CXNxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:53:16 -0400
Message-ID: <4BAA1946.6060703@suse.de>
Date: Wed, 24 Mar 2010 14:53:10 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com> <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com>
In-Reply-To: <4BAA0DFE.1080700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 03/24/2010 02:50 PM, Joerg Roedel wrote:
>>
>>> You can always provide the kernel and module paths as command line
>>> parameters.  It just won't be transparently usable, but if you're using
>>> qemu from the command line, presumably you can live with that.
>>>      
>> I don't want the tool for myself only. A typical perf user expects that
>> it works transparent.
>>    
>
> A typical kvm user uses libvirt, so we can integrate it with that.
>
>>>> Could be easily done using notifier chains already in the kernel.
>>>> Probably implemented with much less than 100 lines of additional code.
>>>>        
>>> And a userspace interface for that.
>>>      
>> Not necessarily. The perf event is configured to measure systemwide kvm
>> by userspace. The kernel side of perf takes care that it stays
>> system-wide even with added vm instances. So in this case the consumer
>> for the notifier would be the perf kernel part. No userspace interface
>> required.
>>    
>
> Someone needs to know about the new guest to fetch its symbols.  Or do
> you want that part in the kernel too?


How about we add a virtio "guest file system access" device? The guest
would then expose its own file system using that device.

On the host side this would simply be a -virtioguestfs
unix:/tmp/guest.fs and you'd get a unix socket that gives you full
access to the guest file system by using commands. I envision something
like:

SEND: GET /proc/version
RECV: Linux version 2.6.27.37-0.1-default (geeko@buildhost) (gcc version
4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP 2009-10-15
14:56:58 +0200

Now all we need is integration in perf to enumerate virtual machines
based on libvirt. If you want to run qemu-kvm directly, just go with
--guestfs=/tmp/guest.fs and perf could fetch all required information
automatically.

This should solve all issues while staying 100% in user space, right?


Alex

