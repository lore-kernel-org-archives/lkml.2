Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937998Ab0CPRNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:13:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60930 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab0CPRNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:13:18 -0400
Message-ID: <4B9FBA8B.8020200@codemonkey.ws>
Date: Tue, 16 Mar 2010 12:06:19 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <20100316095336.GI7961@elte.hu> <4B9F59DE.1060008@redhat.com> <20100316102052.GC10069@elte.hu> <4B9F603B.4080004@redhat.com> <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu>
In-Reply-To: <20100316130840.GA24808@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 08:08 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/16/2010 02:29 PM, Ingo Molnar wrote:
>>      
>    
>>> I mean, i can trust a kernel service and i can trust /proc/kallsyms.
>>>
>>> Can perf trust a random process claiming to be Qemu? What's the trust
>>> mechanism here?
>>>        
>> Obviously you can't trust anything you get from a guest, no matter how you
>> get it.
>>      
> I'm not talking about the symbol strings and addresses, and the object
> contents for allocation (or debuginfo). I'm talking about the basic protocol
> of establishing which guest is which.
>
> I.e. we really want to be able users to:
>
>   1) have it all working with a single guest, without having to specify 'which'
>      guest (qemu PID) to work with. That is the dominant usecase both for
>      developers and for a fair portion of testers.
>    

You're making too many assumptions.

There is no list of guests anymore than there is a list of web browsers.

You can have a multi-tenant scenario where you have distinct groups of 
virtual machines running as unprivileged users.

>   2) Have some reasonable symbolic identification for guests. For example a
>      usable approach would be to have 'perf kvm list', which would list all
>      currently active guests:
>
>       $ perf kvm list
>         [1] Fedora
>         [2] OpenSuse
>         [3] Windows-XP
>         [4] Windows-7
>
>      And from that point on 'perf kvm -g OpenSuse record' would do the obvious
>      thing. Users will be able to just use the 'OpenSuse' symbolic name for
>      that guest, even if the guest got restarted and switched its main PID.
>    

Does "perf kvm list" always run as root?  What if two unprivileged users 
both have a VM named "Fedora"?

If we look at the use-case, it's going to be something like, a user is 
creating virtual machines and wants to get performance information about 
them.

Having to run a separate tool like perf is not going to be what they 
would expect they had to do.  Instead, they would either use their 
existing GUI tool (like virt-manager) or they would use their management 
interface (either QMP or libvirt).

The complexity of interaction is due to the fact that perf shouldn't be 
a stand alone tool.  It should be a library or something with a 
programmatic interface that another tool can make use of.

Regards,

Anthony Liguori

> Is such a scheme possible/available? I suspect all the KVM configuration tools
> (i havent used them in some time - gui and command-line tools alike) use
> similar methods to ease guest management?
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

