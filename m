Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0CVSPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:15:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab0CVSPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:15:37 -0400
Message-ID: <4BA7B3B2.7050600@redhat.com>
Date: Mon, 22 Mar 2010 20:15:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <4BA6900B.1040408@redhat.com> <20100321215207.GA13219@elte.hu> <4BA712F0.5030806@redhat.com> <20100322112340.GD3483@elte.hu> <4BA76746.1000505@redhat.com> <20100322144701.GF14201@elte.hu>
In-Reply-To: <20100322144701.GF14201@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 04:47 PM, Ingo Molnar wrote:
>
>>> If you are interested in the first-hand experience of the people who are
>>> doing the perf work then here it is: by far the biggest reason for perf
>>> success and perf usability is the integration of the user-space tooling
>>> with the kernel-space bits, into a single repository and project.
>>>        
>> Please take a look at the kvm integration code in qemu as a fraction of the
>> whole code base.
>>      
> You have to admit that much of Qemu's past 2-3 years of development was
> motivated by Linux/KVM (i'd say more than 50% of the code).

kvm certainly revitalized qemu development.

> As such it's one
> and the same code base - you just continue to define Qemu to be different from
> KVM.
>    

It's not the same code base.  kvm provides a cpu virtualization service, 
qemu uses it.  There could be other users.  qemu could go away one day 
and be replaced by something else (tools/kvm?), and kvm would be unaffected.

> I very much remember how Qemu looked like _before_ KVM: it was a struggling,
> dying project. KVM clearly changed that.
>    

I'm a hero.

>>> The very move you are opposing so vehemently for KVM.
>>>        
>> I don't want to fracture a working community.
>>      
> Would you accept (or at least not NAK) a new tools/kvm/ tool that builds
> tooling from grounds up, while leaving Qemu untouched? [assuming it's all
> clean code, etc.]
>    

I couldn't NAK tools/kvm any more than I could NAK a new project outside 
the kernel repository.  IMO it would be duplicated effort, but like I 
mentioned before, I can't tell volunteers what to do, only recommend 
that they join the existing effort.

> Although i have doubts about how well that would work 'against' your opinion:
> such a tool would need lots of KVM-side features and a positive attitude from
> you to be really useful. There's a lot of missing functionality to cover.
>    

Functionality that can be implemented in userspace will not be accepted 
into kvm unless there are very good reasons why it should be.  Things 
that belong in kvm will be more than welcome.

>> Seems like perf is also split, with sysprof being developed outside the
>> kernel.  Will you bring sysprof into the kernel?  Will every feature be
>> duplicated in prof and sysprof?
>>      
> I'd prefer if sysprof merged into perf as 'perf view' - but its maintainer
> does not want that - which is perfectly OK.

You spared him the flamewar, I hope.

> So we are building equivalent
> functionality into perf instead.
>    

Ah, duplicating effort.  Great.

> Think about it like Firefox plugins: the main Firefox project picks up the
> functionality of the most popular Firefox plugins all the time. Session Saver,
> Tab Mix Plus, etc. were all in essence 'merged' (in functionality, not in
> code) into the 'reference' Firefox project.
>    

There's a difference between absorbing a small plugin and duplicating a 
project.

-- 
error compiling committee.c: too many arguments to function

