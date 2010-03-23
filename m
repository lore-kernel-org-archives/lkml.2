Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0CWQki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:40:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117Ab0CWQkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:40:37 -0400
Message-ID: <4BA8EEDE.8070309@redhat.com>
Date: Tue, 23 Mar 2010 18:39:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org>
In-Reply-To: <20100323140608.GJ1940@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 04:06 PM, Joerg Roedel wrote:
> On Mon, Mar 22, 2010 at 05:06:17PM -0500, Anthony Liguori wrote:
>    
>> There always needs to be a system wide entity.  There are two ways to
>> enumerate instances from that system wide entity.  You can centralize
>> the creation of instances and there by maintain an list of current
>> instances.  You can also allow instances to be created in a
>> decentralized manner and provide a standard mechanism for instances to
>> register themselves with the system wide entity.
>>      
> And this system wide entity is the kvm module. It creates instances of
> 'struct kvm' and destroys them. I see no problem if we just attach a
> name to every instance with a good default value like kvm0, kvm1 ... or
> guest0, guest1 ... User-space can override the name if it wants. The kvm
> module takes care about the names being unique.
>    

So, two users can't have a guest named MyGuest each?  What about 
namespace support?  There's a lot of work in virtualizing all kernel 
namespaces, you're adding to that.  What about notifications when guests 
are added or removed?

> This is very much the same as network card numbering is implemented in
> the kernel.
> Forcing perf to talk to qemu or even libvirt produces to much overhead
> imho. Instrumentation only produces useful results with low overhead.
>
>    

It's a setup cost only.

-- 
error compiling committee.c: too many arguments to function

