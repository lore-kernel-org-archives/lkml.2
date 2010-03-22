Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0CVWGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:06:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:53497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0CVWG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:06:29 -0400
Message-ID: <4BA7E9D9.5060800@codemonkey.ws>
Date: Mon, 22 Mar 2010 17:06:17 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com>
In-Reply-To: <4BA7C96D.2020702@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 02:47 PM, Avi Kivity wrote:
> On 03/22/2010 09:27 PM, Ingo Molnar wrote:
>>
>>> If your position basically boils down to, we can't trust userspace
>>> and we can always trust the kernel, I want to eliminate any
>>> userspace path, then I can't really help you out.
>> Why would you want to 'help me out'? I can tell a good solution from 
>> a bad one
>> just fine.
>
> You are basically making a kernel implementation a requirement, 
> instead of something that follows from the requirement.
>
>> You should instead read the long list of disadvantages above, invert 
>> them and
>> list then as advantages for the kernel-based vcpu enumeration 
>> solution, apply
>> common sense and go admit to yourself that indeed in this situation a 
>> kernel
>> provided enumeration of vcpu contexts is the most robust solution.
>
> Having qemu enumerate guests one way or another is not a good idea IMO 
> since it is focused on one guest and doesn't have a system-wide entity.

There always needs to be a system wide entity.  There are two ways to 
enumerate instances from that system wide entity.  You can centralize 
the creation of instances and there by maintain an list of current 
instances.  You can also allow instances to be created in a 
decentralized manner and provide a standard mechanism for instances to 
register themselves with the system wide entity.

IOW, it's the difference between asking libvirtd to exec(qemu) vs 
allowing a user to exec(qemu) and having qemu connect to a well known 
unix domain socket for libvirt to tell libvirtd that it exists.

The later approach has a number of advantages.  libvirt already supports 
both models.  The former is the '/system' uri and the later is the 
'/session' uri.

What I'm proposing, is to use the host file system as the system wide 
entity instead of libvirtd.  libvirtd can monitor the host file system 
to participate in these activities but ultimately, moving this 
functionality out of libvirtd means that it becomes the standard 
mechanism for all qemu instances regardless of how they're launched.

Regards,

Anthony Liguori

>   A userspace system-wide entity will work just as well as kernel 
> implementation, without its disadvantages.
>

