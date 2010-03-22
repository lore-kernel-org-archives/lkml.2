Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0CVGiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 02:38:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab0CVGiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 02:38:11 -0400
Message-ID: <4BA71012.7070004@redhat.com>
Date: Mon, 22 Mar 2010 08:37:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
References: <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com> <20100321203704.GB30194@elte.hu>
In-Reply-To: <20100321203704.GB30194@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 10:37 PM, Ingo Molnar wrote:
>
>> That includes the guest kernel.  If you can deploy a new kernel in the
>> guest, presumably you can deploy a userspace package.
>>      
> Note that with perf we can instrument the guest with zero guest-kernel
> modifications as well.
>
> We try to reduce the guest impact to a bare minimum, as the difficulties in
> deployment are function of the cross section surface to the guest.
>
> Also, note that the kernel is special with regards to instrumentation: since
> this is the kernel project, we are doing kernel space changes, as we are doing
> them _anyway_. So adding symbol resolution capabilities would be a minimal
> addition to that - while adding a while new guest package for the demon would
> significantly increase the cross section surface.
>    

It's true that for us, changing the kernel is easier than changing the 
rest of the guest.  IMO we should still resist the temptation to go the 
easy path and do the right thing (I understand we disagree about what 
the right thing is).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

