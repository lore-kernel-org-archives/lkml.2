Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0CRO77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:59:59 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54299 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab0CRO75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:59:57 -0400
Message-ID: <4BA23FE1.5050402@codemonkey.ws>
Date: Thu, 18 Mar 2010 09:59:45 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA20EB8.60707@redhat.com> <20100318114821.GB13168@elte.hu> <4BA21B09.6060706@redhat.com> <20100318130047.GA7424@elte.hu>
In-Reply-To: <20100318130047.GA7424@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 08:00 AM, Ingo Molnar wrote:
>> [...]  kvm in fact knows nothing about vga, to take your last
>> example. [...]
>>      
> Look at the VGA dirty bitmap optimization a'ka the KVM_GET_DIRTY_LOG ioctl.
>
> See qemu/kvm-all.c's kvm_physical_sync_dirty_bitmap().
>
> It started out as a VGA optimization (also used by live migration) and even
> today it's mostly used by the VGA drivers - albeit a weak one.
>
> I wish there were stronger VGA optimizations implemented, copying the dirty
> bitmap is not a particularly performant solution. (although it's certainly
> better than full emulation) Graphics performance is one of the more painful
> aspects of KVM usability today.
>    

We have to maintain a dirty bitmap because we don't have a paravirtual 
graphics driver.  IOW, someone needs to write an Xorg driver.

Ideally, we could just implement a Linux framebuffer device, right?  
Well, we took that approach in Xen and that sucks even worse because the 
Xorg framebuffer driver doesn't implement any of the optimizations that 
the Linux framebuffer supports and the Xorg driver does not provide use 
the kernel's interfaces for providing update regions.

Of course, we need to pull in X into the kernel to fix this, right?

Any sufficiently complicated piece of software is going to interact with 
a lot of other projects.  The solution is not to pull it all into one 
massive repository.  It's to build relationships and to find ways to 
efficiently work with the various communities.

And we're working on this with X.  We'll have a paravirtual graphics 
driver very soon.  There are no magic solutions.  We need more 
developers working on the hard problems.

Regards,

Anthony Liguori
