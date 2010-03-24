Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0CXPIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:08:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab0CXPII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:08:08 -0400
Message-ID: <4BAA2A89.7080008@redhat.com>
Date: Wed, 24 Mar 2010 17:06:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
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
References: <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com> <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <4BAA1946.6060703@suse.de> <4BAA1ADD.9090502@redhat.com> <4BAA2080.5020902@suse.de>
In-Reply-To: <4BAA2080.5020902@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 04:24 PM, Alexander Graf wrote:
> Avi Kivity wrote:
>    
>> On 03/24/2010 03:53 PM, Alexander Graf wrote:
>>      
>>>        
>>>> Someone needs to know about the new guest to fetch its symbols.  Or do
>>>> you want that part in the kernel too?
>>>>
>>>>          
>>> How about we add a virtio "guest file system access" device? The guest
>>> would then expose its own file system using that device.
>>>
>>> On the host side this would simply be a -virtioguestfs
>>> unix:/tmp/guest.fs and you'd get a unix socket that gives you full
>>> access to the guest file system by using commands. I envision something
>>> like:
>>>
>>>        
>> The idea is to use a dedicated channel over virtio-serial.  If the
>> channel is present the file server can serve files over it.
>>      
> The file server being a kernel module inside the guest? We want to be
> able to serve things as early and hassle free as possible, so in this
> case I agree with Ingo that a kernel module is superior.
>    

No, just a daemon.  If it's important enough we can get distributions to 
package it by default, and then it will be hassle free.  If "early 
enough" is also so important, we can get it to start up on initrd.  If 
it's really critical, we can patch grub to serve the files as well.

>>> SEND: GET /proc/version
>>> RECV: Linux version 2.6.27.37-0.1-default (geeko@buildhost) (gcc version
>>> 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP 2009-10-15
>>> 14:56:58 +0200
>>>
>>> Now all we need is integration in perf to enumerate virtual machines
>>> based on libvirt. If you want to run qemu-kvm directly, just go with
>>> --guestfs=/tmp/guest.fs and perf could fetch all required information
>>> automatically.
>>>
>>> This should solve all issues while staying 100% in user space, right?
>>>
>>>        
>> Yeah, needs a fuse filesystem to populate the host namespace (kind of
>> sshfs over virtio-serial).
>>      
> I don't see why we need a fuse filesystem. We can of course create one
> later on. But for now all you need is a user connecting to that socket.
>    

If the perf app knows the protocol, no problem.  But leave perf with 
pure filesystem access and hide the details in fuse.

-- 
error compiling committee.c: too many arguments to function

