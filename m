Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0CVSal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:30:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57166 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0CVSak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:30:40 -0400
Message-ID: <4BA7B74C.7000905@codemonkey.ws>
Date: Mon, 22 Mar 2010 13:30:36 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100321215455.GB13219@elte.hu> <4BA7187E.3050405@redhat.com> <20100322111411.GC3483@elte.hu> <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA7960A.4020504@codemonkey.ws> <20100322171150.GA15795@elte.hu>
In-Reply-To: <20100322171150.GA15795@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 12:11 PM, Ingo Molnar wrote:
> * Anthony Liguori<anthony@codemonkey.ws>  wrote:
>
>    
>>>   - Easy default reference to guest instances, and a way for tools to
>>>     reference them symbolically as well in the multi-guest case. Preferably
>>>     something trustable and kernel-provided - not some indirect information
>>>     like a PID file created by libvirt-manager or so.
>>>        
>> A guest is not a KVM concept. [...]
>>      
> Well, in a sense a guest is a KVM concept too: it's in essence represented via
> the 'vcpu state attached to a struct mm' abstraction that is attached to the
> /dev/kvm file descriptor attached to a Linux process.
>
> Multiple vcpus can be started by the same process to represent SMP, but the
> whole guest notion is present: a Linux MM that carries KVM state.
>
> In that sense when we type 'perf kvm list' we'd like to get a list of all
> currently present guests that the developer has permission to profile: i.e.
> we'd like a list of all [debuggable] Linux tasks that have a KVM instance
> attached to them.
>
> A convenient way to do that would be to use the Qemu process's ->comm[] name,
> and to have a KVM ioctl that gets us a list of all vcpus that the querying
> task has ptrace permission to. [the standard permission check we do for
> instrumentation]
>
> No need for communication with Qemu for that - just an ioctl, and an
> always-guaranteed result that works fine on a whole-system and on a per user
> basis as well.
>    

You need a way to interact with the guest which means you need some type 
of device.  All of the interesting devices are implemented in qemu so 
you're going to have to interact with qemu if you want meaningful 
interaction with a guest.

Regards,

Anthony Liguori

> Thanks,
>
> 	Ingo
>    

