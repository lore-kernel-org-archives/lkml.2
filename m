Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0CRMAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 08:00:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:53212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab0CRMAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 08:00:19 -0400
Message-ID: <4BA215CC.5090801@suse.de>
Date: Thu, 18 Mar 2010 13:00:12 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
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
References: <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de> <20100318101025.GA13073@elte.hu> <4BA1FEB0.7000400@redhat.com> <20100318113527.GA13168@elte.hu>
In-Reply-To: <20100318113527.GA13168@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
>
>   
>>> Still it's _very_ useful to have a single reference implementation under 
>>> tools/perf/ where we concentrate the best of the code. That is where we 
>>> make sure that each new kernel feature is appropriately implemented in 
>>> user-space as well, that the combination works well together and is 
>>> releasable to users. That is what keeps us all honest: the latency of 
>>> features is much lower, and there's no ping-pong of blame going on between 
>>> the two components in case of bugs or in case of misfeatures.
>>>       
>> That would make sense for a truly minimal userspace for kvm: we once had a 
>> tool called kvmctl which was used to run tests (since folded into qemu).  It 
>> didn't contain a GUI and was unable to run a general purpose guest.  It was 
>> a few hundred lines of code, and indeed patches to kvmctl had a much closer 
>> correspondence to patches with kvm (though still low, as most kvm patches 
>> don't modify the ABI).
>>     
>
> If it's functional to the extent of at least allowing say a serial console via 
> the console (like the UML binary allows) i'd expect the minimal user-space to 
> quickly grow out of this minimal state. The rest will be history.
>
> Maybe this is a better, simpler (and much cleaner and less controversial) 
> approach than moving a 'full' copy of qemu there.
>
> There's certainly no risk: if qemu stays dominant then nothing is lost 
> [tools/kvm/ can be removed after some time], and if this clean base works out 
> fine then the useful qemu technologies will move over to it gradually and 
> without much fuss, and the developers will move with it as well.
>
> If it's just a token effort with near zero utility to begin with it certainly 
> wont take off.
>
> Once it's there in tools/kvm/ and bootable i'd certainly hack up some quick 
> xlib based VGA output capability myself - it's not that hard ;-) It would also 
> allow me to test whether latest-KVM still boots fine in a much simpler way. 
> (most of my testboxes dont have qemu installed)
>
> So you have one user signed up for that already ;-)
>   

Alright, you just volunteered. Just give it a go and try to implement
the "oh so simple" KVM frontend while maintaining compatibility with at
least a few older Linux guests. My guess is that you'll realize it's a
dead end before committing anything to the kernel source tree. But
really, just try it out.


Good Luck

Alex
