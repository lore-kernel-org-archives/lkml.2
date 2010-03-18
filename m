Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0CRO10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab0CRO1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:27:24 -0400
Message-ID: <4BA237E2.10303@redhat.com>
Date: Thu, 18 Mar 2010 16:25:38 +0200
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
References: <20100318085607.GB2157@elte.hu> <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de> <20100318101025.GA13073@elte.hu> <4BA1FEB0.7000400@redhat.com> <20100318113527.GA13168@elte.hu> <y0m4okdzu4z.fsf@fche.csb> <20100318130226.GB7424@elte.hu> <4BA22663.7070509@redhat.com> <20100318133124.GA25642@elte.hu> <4BA22E9E.4000607@redhat.com> <20100318135700.GC25642@elte.hu>
In-Reply-To: <20100318135700.GC25642@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 03:57 PM, Ingo Molnar wrote:
>
>> [...]  RHEL 5 is still on 2.6.18, for example.  Users
>> don't like their kernels updated unless absolutely necessary, with
>> good reason.
>>      
> Nope - RHEL 5 is on a 2.6.18 base for entirely different reasons.
>    

All the reasons have 'stability' in them.

>> Kernel updates = reboots.
>>      
> If you check the update frequency of RHEL 5 kernels you'll see that it's
> comparable to that of Fedora.
>    

I'm sorry to say that's pretty bad.  Users don't want to update their 
kernels.

>>>   - Qemu on the other hand is not upgraded with (nearly) that level of urgency.
>>>     Completely new versions will generally have to wait for the next distro
>>>     release.
>>>        
>> F12 recently updated to 2.6.32.  This is probably due to 2.6.31.stable
>> dropping away, and no capacity at Fedora to maintain it on their own.  So
>> they are caught in a bind - stay on 2.6.31 and expose users to security
>> vulnerabilities or move to 2.6.32 and cause regressions.  Not a happy
>> choice.
>>      
> Happy choice or not, this is what i said is the distro practice these days. (i
> dont know all the distros that well so i'm sure there's differences)
>    

So in addition to all the normal kernel regressions, you want to force 
tools/kvm/ regressions on users.

>> I don't mind at all if rawhide users run on the latest and greatest, but
>> release users deserve a little more stability.
>>      
> What are you suggesting, that released versions of KVM are not reliable? Of
> course any tools/ bits are release engineered just as much as the rest of KVM
> ...
>    

No, I am suggesting qemu-kvm.git is not as stable as released versions 
(and won't get fixed backported).  Keep in mind that unlike many 
userspace applications, qemu exposes an ABI to guests which we must keep 
compatible.

-- 
error compiling committee.c: too many arguments to function

