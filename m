Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0CXJb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:31:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43053 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0CXJb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:31:56 -0400
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
From: Andi Kleen <andi@firstfloor.org>
References: <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws>
	<20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com>
	<4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org>
	<4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org>
	<87hbo6fgpy.fsf@basil.nowhere.org> <4BA9B454.5090908@redhat.com>
	<20100324073854.GD20695@one.firstfloor.org>
	<4BA9D459.6070502@redhat.com>
Date: Wed, 24 Mar 2010 10:31:50 +0100
In-Reply-To: <4BA9D459.6070502@redhat.com> (Avi Kivity's message of "Wed, 24 Mar 2010 10:59:05 +0200")
Message-ID: <878w9if4l5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> On 03/24/2010 09:38 AM, Andi Kleen wrote:
>>> If you're profiling a single guest it makes more sense to do this from
>>> inside the guest - you can profile userspace as well as the kernel.
>>>      
>> I'm interested in debugging the guest without guest cooperation.
>>
>> In many cases qemu's new gdb stub works for that, but in some cases
>> I would prefer instruction/branch traces over standard gdb style
>> debugging.
>>    
>
> Isn't gdb supposed to be able to use branch traces? 

AFAIK not. The ptrace interface is only used by idb I believe.
I might be wrong on that.

Not sure if there is even a remote protocol command for 
branch traces either.

There's a concept of "tracepoints" in the protocol, but it 
doesn't quite match at.

> It makes sense to
> expose them via the gdb stub then.  Not to say an external tool
> doesn't make sense.

Ok that would work for me too. As long as I can set start/stop
triggers and pipe the log somewhere it's fine for me.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
