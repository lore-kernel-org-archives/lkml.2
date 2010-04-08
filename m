Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753Ab0DHO3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:29:18 -0400
Received: from mamba.nagafix.co.uk ([194.145.196.68]:42323 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757413Ab0DHO3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:29:17 -0400
Message-ID: <4BBDE839.4040106@nagafix.co.uk>
Date: Thu, 08 Apr 2010 15:29:13 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
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
References: <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org> <4BAA2BF7.4060407@redhat.com> <20100324154605.GG14800@8bytes.org> <4BAA3496.2010901@redhat.com> <20100324155927.GI14800@8bytes.org> <4BAA393A.9000105@redhat.com> <20100324164000.GM14800@8bytes.org> <4BAA4211.2000209@redhat.com>
In-Reply-To: <4BAA4211.2000209@redhat.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=F18AD6BB;
	url=http://users.nagafix.co.uk/~antoine/antoine.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 03/24/2010 06:40 PM, Joerg Roedel wrote:
>>
>>> Looks trivial to find a guest, less so with enumerating (still doable).
>>>      
>> Not so trival and even more likely to break. Even it perf has the pid of
>> the process and wants to find the directory it has to do:
>>
>> 1. Get the uid of the process
>> 2. Find the username for the uid
>> 3. Use the username to find the home-directory
>>
>> Steps 2. and 3. need nsswitch and/or pam access to get this information
>> from whatever source the admin has configured. And depending on what the
>> source is it may be temporarily unavailable causing nasty timeouts. In
>> short, there are many weak parts in that chain making it more likely to
>> break.
>>    
> 
> It's true.  If the kernel provides something, there are fewer things
> that can break.  But if your system is so broken that you can't resolve
> uids, fix that before running perf.  Must we design perf for that case?
uid to username can fail when using chroots, or worse point to an
incorrect location (and yes, I do use this)

Sorry if this has been covered / discussion has moved on. Just catching
up with the 500+ messages in my inbox..

Antoine


> 
> After all, 'ls -l' will break under the same circumstances.  It's hard
> to imagine doing useful work when that doesn't work.
> 
>> A kernel-based approach with /proc/<pid>/kvm does not have those issues
>> (and to repeat myself, it is independent from the userspace being used).
>>    
> 
> It has other issues, which are IMO more problematic.
> 
