Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0CVHTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab0CVHTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:19:19 -0400
Message-ID: <4BA719E3.6070002@redhat.com>
Date: Mon, 22 Mar 2010 09:18:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA47AD0.2010509@redhat.com> <20100321190656.GC25922@elte.hu> <4BA68009.5010906@redhat.com> <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321220052.GC13219@elte.hu>
In-Reply-To: <20100321220052.GC13219@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 12:00 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>> Consider the _other_ examples that are a lot more clear:
>>>
>>>     ' If you expose paravirt spilocks via KVM please also make sure the KVM
>>>       tooling can make use of it, has an option for it to configure it, and
>>>       that it has sufficient efficiency statistics displayed in the tool for
>>>       admins to monitor.'
>>>
>>>     ' If you create this new paravirt driver then please also make sure it can
>>>       be configured in the tooling. '
>>>
>>>     ' Please also add a testcase for this bug to tools/kvm/testcases/ so we dont
>>>       repeat this same mistake in the future. '
>>>        
>> All three happen quite commonly in qemu/kvm development.  Of course someone
>> who develops a feature also develops a patch that exposes it in qemu.  There
>> are several test cases in qemu-kvm.git/kvm/user/test.
>>      
> If that is the theory then it has failed to trickle through in practice. As
> you know i have reported a long list of usability problems with hardly a look.
> That list could be created by pretty much anyone spending a few minutes of
> getting a first impression with qemu-kvm.
>    

It does happen in practice, just not in the GUI areas, since no one is 
working on them.  I am not going to condition a qcow2 reliability fix to 
a gtk GUI.

> So something is seriously wrong in KVM land, to pretty much anyone trying it
> for the first time. I have explained how i see the root cause of that, while
> you seem to suggest that there's nothing wrong to begin with. I guess we'll
> have to agree to disagree on that.
>    

Not anyone trying it for the first time.  RHEV-M users will see a 
polished GUI that can be used to manage thousands of guests and hosts.  
I presume IBM and Siemens (and all other contributors) users will also 
enjoy a good user experience with their respective products.  Qemu is 
not the only GUI for kvm.

So far only one company was interested in a qemu GUI - the makers of 
virtualbox.  Unfortunately they chose not to contribute that back to 
qemu, and no one was sufficiently motivated to pick out the bits and try 
to merge them.

Again, if you are interested in a qemu GUI, you either have to write it 
yourself or convince someone else to do it.  My own plate is full and my 
priorities are clear.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

