Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab0CVT3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:29:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511Ab0CVT3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:29:18 -0400
Message-ID: <4BA7C4FA.5080604@redhat.com>
Date: Mon, 22 Mar 2010 21:28:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org> <20100322122228.GH3483@elte.hu> <20100322134633.GD1940@8bytes.org> <20100322163215.GC18796@elte.hu> <20100322192059.GG1940@8bytes.org>
In-Reply-To: <20100322192059.GG1940@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 09:20 PM, Joerg Roedel wrote:
>
>> Why doesnt it solve the bisectability problem? The kernel repo is supposed to
>> be bisectable so that problem would be solved.
>>      
> Because Marcelo and Avi try to keep as close to upstream qemu as
> possible. So the qemu repo is regularly merged in qemu-kvm and if you
> want to bisect you may end up somewhere in the middle of the qemu
> repository which has only very minimal kvm-support.
> The problem here is that two qemu repositorys exist. But the current
> effort of Anthony is directed to create a single qemu repository. But
> thats not done overnight.
>    

It's in fact possible to bisect qemu-kvm.git.  If you end up in 
qemu.git, do a 'git bisect skip'.  If you end up in a merge, call the 
merge point A, bisect A^1..A^2, each time merging A^1 before compiling 
(the merge is always trivial due to the way we do it).

Not fun, but it works.  When we complete merging kvm integration into 
qemu.git, this problem will disappear.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

