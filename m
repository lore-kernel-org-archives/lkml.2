Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab0CXPqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:46:11 -0400
Received: from 8bytes.org ([88.198.83.132]:40852 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab0CXPqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:46:09 -0400
Date: Wed, 24 Mar 2010 16:46:05 +0100
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
Message-ID: <20100324154605.GG14800@8bytes.org>
References: <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com> <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org> <4BAA2BF7.4060407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA2BF7.4060407@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 05:12:55PM +0200, Avi Kivity wrote:
> On 03/24/2010 05:01 PM, Joerg Roedel wrote:
>> $ cd /sys/kvm/guest0
>> $ ls -l
>> -r-------- 1 root root 0 2009-08-17 12:05 name
>> dr-x------ 1 root root 0 2009-08-17 12:05 fs
>> $ cat name
>> guest0
>> $ # ...
>>
>> The fs/ directory is used as the mount point for the guest root fs.
>
> The problem is /sys/kvm, not /sys/kvm/fs.

I am not tied to /sys/kvm. We could also use /proc/<pid>/kvm/ for
example. This would keep anything in the process space (except for the
global list of VMs which we should have anyway).

>> What I meant was: perf-kernel puts the guest-name into every sample and
>> perf-userspace accesses /sys/kvm/guest_name/fs/ later to resolve the
>> symbols. I leave the question of how the guest-fs is exposed to the host
>> out of this discussion. We should discuss this seperatly.
>
> How I see it: perf-kernel puts the guest pid into every sample, and  
> perf-userspace uses that to resolve to a mountpoint served by fuse, or  
> to a unix domain socket that serves the files.

We need a bit more information than just the qemu-pid, but yes, this
would also work out.

>> If a vm breaks into qemu it can access the host file system which is the
>> bigger problem. In this case there is no isolation anymore. From that
>> context it can even kill other VMs of the same user independent of a
>> hypothetical /sys/kvm/.
>
> It cannot.  sVirt labels the disk image and other files qemu needs with  
> the appropriate label, and everything else is off limits.  Even if you  
> run the guest as root, it won't have access to other files.

See my reply to Daniel's email.

>> Yes, but its different from the implementation point-of-view. For the
>> user it surely all plays together.
>
> We need qemu to cooperate for mmio tracing, and we can cooperate with  
> qemu for symbol resolution.  If it prevents adding another kernel API,  
> that's a win from my POV.

Thats true. Probably qemu can inject this information in the
kvm-trace-events stream.

	Joerg

