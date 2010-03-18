Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0CROwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:52:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab0CROwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:52:36 -0400
Message-ID: <4BA23E09.2050701@redhat.com>
Date: Thu, 18 Mar 2010 16:51:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Frank Ch. Eigler" <fche@redhat.com>, Alexander Graf <agraf@suse.de>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
References: <20100318101025.GA13073@elte.hu> <4BA1FEB0.7000400@redhat.com> <20100318113527.GA13168@elte.hu> <y0m4okdzu4z.fsf@fche.csb> <20100318130226.GB7424@elte.hu> <4BA22663.7070509@redhat.com> <20100318133124.GA25642@elte.hu> <4BA22E9E.4000607@redhat.com> <20100318135700.GC25642@elte.hu> <4BA237E2.10303@redhat.com> <20100318143656.GA20182@elte.hu>
In-Reply-To: <20100318143656.GA20182@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 04:36 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>> Happy choice or not, this is what i said is the distro practice these
>>> days. (i dont know all the distros that well so i'm sure there's
>>> differences)
>>>        
>> So in addition to all the normal kernel regressions, you want to force
>> tools/kvm/ regressions on users.
>>      
> So instead you force a NxN compatibility matrix [all versions of qemu combined
> with all versions of the kernel] instead of a linear N versions matrix with a
> clear focus on the last version. Brilliant engineering i have to say ;-)
>    

Thanks.  In fact with have an QxKxGxT compatibility matrix since we need 
to keep compatibility with guests and with tools.  Since the easiest 
interface to keep compatible is the qemu/kernel interface, allowing the 
kernel and qemu to change independently allows reducing the 
compatibility matrix while still providing some improvements.

Regardless of that I'd keep binary compatibility anyway.  Not everyone 
is on the update treadmill with everything updating every three months 
and those people appreciate stability.  I intend to keep providing it.

> Also, by your argument the kernel should be split up into a micro-kernel, with
> different packages for KVM, scheduler, drivers, upgradeable separately.
>    

Some kernels do provide some of that facility (without being 
microkernels), for example the Windows and RHEL kernels.  So it seems 
people want it.

> That would be a nightmare. (i can detail many facets of that nightmare if you
> insist but i'll spare the electrons for now) Fortunately few kernel developers
> share your views about this.
>    

I'm not sure you know my views about this.

>>>> I don't mind at all if rawhide users run on the latest and greatest, but
>>>> release users deserve a little more stability.
>>>>          
>>> What are you suggesting, that released versions of KVM are not reliable?
>>> Of course any tools/ bits are release engineered just as much as the rest
>>> of KVM ...
>>>        
>> No, I am suggesting qemu-kvm.git is not as stable as released versions (and
>> won't get fixed backported).  Keep in mind that unlike many userspace
>> applications, qemu exposes an ABI to guests which we must keep compatible.
>>      
> I think you still dont understand it: if a tool moves to the kernel repo, then
> it is _released stable_ together with the next stable kernel.
>    

I was confused by the talk about 2.6.34-rc1, which isn't stable.

-- 
error compiling committee.c: too many arguments to function

