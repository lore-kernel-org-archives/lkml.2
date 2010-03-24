Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab0CXPxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:53:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab0CXPxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:53:30 -0400
Message-ID: <4BAA3556.2040802@redhat.com>
Date: Wed, 24 Mar 2010 17:52:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Daniel P. Berrange" <berrange@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
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
References: <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org> <20100324152653.GA12225@redhat.com> <20100324153746.GF14800@8bytes.org> <4BAA3323.9000405@redhat.com> <20100324155041.GH14800@8bytes.org>
In-Reply-To: <20100324155041.GH14800@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 05:50 PM, Joerg Roedel wrote:
> On Wed, Mar 24, 2010 at 05:43:31PM +0200, Avi Kivity wrote:
>    
>> On 03/24/2010 05:37 PM, Joerg Roedel wrote:
>>      
>>> Even better. So a guest which breaks out can't even access its own
>>> /sys/kvm/ directory. Perfect, it doesn't need that access anyway.
>>>        
>> But what security label does that directory have?  How can we make sure
>> that whoever needs access to those files, gets them?
>>
>> Automatically created objects don't work well with that model.  They're
>> simply missing information.
>>      
> If we go the /proc/<pid>/kvm way then the directory should probably
> inherit the label from /proc/<pid>/?
>    

That's a security policy.  The security people like their policies 
outside the kernel.

For example, they may want a label that allows a trace context to read 
the data, and also qemu itself for introspection.

> Same could be applied to /sys/kvm/guest/ if we decide for it. The VM is
> still bound to a single process with a /proc/<pid>  after all.
>    

Ditto.

-- 
error compiling committee.c: too many arguments to function

