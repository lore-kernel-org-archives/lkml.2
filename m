Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab0CXQJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:09:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428Ab0CXQJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:09:52 -0400
Message-ID: <4BAA393A.9000105@redhat.com>
Date: Wed, 24 Mar 2010 18:09:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
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
References: <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org> <4BAA2BF7.4060407@redhat.com> <20100324154605.GG14800@8bytes.org> <4BAA3496.2010901@redhat.com> <20100324155927.GI14800@8bytes.org>
In-Reply-To: <20100324155927.GI14800@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 05:59 PM, Joerg Roedel wrote:
>
>    
>>> I am not tied to /sys/kvm. We could also use /proc/<pid>/kvm/ for
>>> example. This would keep anything in the process space (except for the
>>> global list of VMs which we should have anyway).
>>>
>>>        
>> How about ~/.qemu/guests/$pid?
>>      
> That makes it hard for perf to find it and even harder to get a list of
> all VMs.

Looks trivial to find a guest, less so with enumerating (still doable).

>   With /proc/<pid>/kvm/guest we could symlink all guest
> directories to /proc/kvm/ and perf reads the list from there. Also perf
> can easily derive the directory for a guest from its pid.
> Last but not least its kernel-created and thus independent from the
> userspace part being used.
>    

Doesn't perf already has a dependency on naming conventions for finding 
debug information?

-- 
error compiling committee.c: too many arguments to function

