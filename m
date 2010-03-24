Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab0CXQrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:47:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0CXQrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:47:45 -0400
Message-ID: <4BAA4211.2000209@redhat.com>
Date: Wed, 24 Mar 2010 18:47:13 +0200
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
References: <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org> <4BAA2BF7.4060407@redhat.com> <20100324154605.GG14800@8bytes.org> <4BAA3496.2010901@redhat.com> <20100324155927.GI14800@8bytes.org> <4BAA393A.9000105@redhat.com> <20100324164000.GM14800@8bytes.org>
In-Reply-To: <20100324164000.GM14800@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 06:40 PM, Joerg Roedel wrote:
>
>> Looks trivial to find a guest, less so with enumerating (still doable).
>>      
> Not so trival and even more likely to break. Even it perf has the pid of
> the process and wants to find the directory it has to do:
>
> 1. Get the uid of the process
> 2. Find the username for the uid
> 3. Use the username to find the home-directory
>
> Steps 2. and 3. need nsswitch and/or pam access to get this information
> from whatever source the admin has configured. And depending on what the
> source is it may be temporarily unavailable causing nasty timeouts. In
> short, there are many weak parts in that chain making it more likely to
> break.
>    

It's true.  If the kernel provides something, there are fewer things 
that can break.  But if your system is so broken that you can't resolve 
uids, fix that before running perf.  Must we design perf for that case?

After all, 'ls -l' will break under the same circumstances.  It's hard 
to imagine doing useful work when that doesn't work.

> A kernel-based approach with /proc/<pid>/kvm does not have those issues
> (and to repeat myself, it is independent from the userspace being used).
>    

It has other issues, which are IMO more problematic.

-- 
error compiling committee.c: too many arguments to function

