Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0CQDzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:55:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab0CQDzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:55:04 -0400
Message-ID: <4BA05285.3070903@redhat.com>
Date: Wed, 17 Mar 2010 05:54:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Anthony Liguori <aliguori@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <20100316130840.GA24808@elte.hu> <4B9F84C0.70706@redhat.com> <20100316133114.GB575@elte.hu> <y0mbpeo1f1y.fsf@fche.csb> <20100316155221.GA19699@elte.hu> <4B9FC11A.1070507@linux.vnet.ibm.com> <20100316175243.GC23859@elte.hu> <4B9FC8B2.6070404@linux.vnet.ibm.com> <20100316182809.GA26602@elte.hu> <4BA00E6A.7080903@linux.vnet.ibm.com> <20100317004136.GC17472@redhat.com>
In-Reply-To: <20100317004136.GC17472@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 02:41 AM, Frank Ch. Eigler wrote:
> Hi -
>
> On Tue, Mar 16, 2010 at 06:04:10PM -0500, Anthony Liguori wrote:
>    
>> [...]
>> The only way to really address this is to change the interaction.
>> Instead of running perf externally to qemu, we should support a perf
>> command in the qemu monitor that can then tie directly to the perf
>> tooling.  That gives us the best possible user experience.
>>      
> To what extent could this be solved with less crossing of
> isolation/abstraction layers, if the perfctr facilities were properly
> virtualized?
>    

That's the more interesting (by far) usage model.  In general guest 
owners don't have access to the host, and host owners can't (and 
shouldn't) change guests.

Monitoring guests from the host is useful for kvm developers, but less 
so for users.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

