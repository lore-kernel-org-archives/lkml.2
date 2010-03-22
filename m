Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0CVS5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:57:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab0CVS5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:57:31 -0400
Message-ID: <4BA7BD12.20008@redhat.com>
Date: Mon, 22 Mar 2010 20:55:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
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
References: <20100318172805.GB26067@elte.hu>	 <20100322111040.GL13108@8bytes.org> <20100322122228.GH3483@elte.hu>	 <20100322134633.GD1940@8bytes.org> <20100322163215.GC18796@elte.hu>	 <y0mmxy0wa1r.fsf@fche.csb>	 <84144f021003221027t1a3e7d6ft64612654c5e50da@mail.gmail.com>	 <4BA7A9AF.3010806@redhat.com>	 <84144f021003221052lb693f15ped0b432c34cdd8dc@mail.gmail.com>	 <4BA7B119.1070800@redhat.com> <84144f021003221110p79db476fpae25f6997b61b0b9@mail.gmail.com>
In-Reply-To: <84144f021003221110p79db476fpae25f6997b61b0b9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 08:10 PM, Pekka Enberg wrote:
> On Mon, Mar 22, 2010 at 8:04 PM, Avi Kivity<avi@redhat.com>  wrote:
>    
>>> That said, pulling 400 KLOC of code into the kernel sounds really
>>> excessive. Would we need all that if we just do native virtualization
>>> and no actual emulation?
>>>        
>> What is native virtualization and no actual emulation?
>>      
> What I meant with "actual emulation" was running architecture A code
> on architecture B what was qemu's traditional use case. So the
> question was how much of the 400 KLOC do we need for just KVM on all
> the architectures that it supports?
>    

qemu is 620 KLOC.  Without cpu emulation that drops to ~480 KLOC.  Much 
of that is device emulation that is not supported by kvm now (like ARM) 
but some might be needed again in the future (like ARM).

x86-only is perhaps 300 KLOC, but kvm is not x86 only.

And that is with a rudimentary GUI.  GUIs are heavy.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

