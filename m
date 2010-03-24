Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab0CXP73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:59:29 -0400
Received: from 8bytes.org ([88.198.83.132]:59579 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab0CXP72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:59:28 -0400
Date: Wed, 24 Mar 2010 16:59:27 +0100
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
Message-ID: <20100324155927.GI14800@8bytes.org>
References: <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org> <4BAA2BF7.4060407@redhat.com> <20100324154605.GG14800@8bytes.org> <4BAA3496.2010901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA3496.2010901@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 05:49:42PM +0200, Avi Kivity wrote:
> On 03/24/2010 05:46 PM, Joerg Roedel wrote:
>> On Wed, Mar 24, 2010 at 05:12:55PM +0200, Avi Kivity wrote:
>>    
>>> On 03/24/2010 05:01 PM, Joerg Roedel wrote:
>>>      
>>>> $ cd /sys/kvm/guest0
>>>> $ ls -l
>>>> -r-------- 1 root root 0 2009-08-17 12:05 name
>>>> dr-x------ 1 root root 0 2009-08-17 12:05 fs
>>>> $ cat name
>>>> guest0
>>>> $ # ...
>>>>
>>>> The fs/ directory is used as the mount point for the guest root fs.
>>>>        
>>> The problem is /sys/kvm, not /sys/kvm/fs.
>>>      
>> I am not tied to /sys/kvm. We could also use /proc/<pid>/kvm/ for
>> example. This would keep anything in the process space (except for the
>> global list of VMs which we should have anyway).
>>    
>
> How about ~/.qemu/guests/$pid?

That makes it hard for perf to find it and even harder to get a list of
all VMs. With /proc/<pid>/kvm/guest we could symlink all guest
directories to /proc/kvm/ and perf reads the list from there. Also perf
can easily derive the directory for a guest from its pid.
Last but not least its kernel-created and thus independent from the
userspace part being used.

	Joerg

