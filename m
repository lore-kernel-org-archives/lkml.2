Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945Ab0CPXOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 19:14:44 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:49901 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0CPXOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 19:14:43 -0400
Message-ID: <4BA00F1F.1090907@codemonkey.ws>
Date: Tue, 16 Mar 2010 18:07:11 -0500
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
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <20100316102052.GC10069@elte.hu> <4B9F603B.4080004@redhat.com> <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu>
In-Reply-To: <20100316173940.GA23859@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 12:39 PM, Ingo Molnar wrote:
>> If we look at the use-case, it's going to be something like, a user is
>> creating virtual machines and wants to get performance information about
>> them.
>>
>> Having to run a separate tool like perf is not going to be what they would
>> expect they had to do.  Instead, they would either use their existing GUI
>> tool (like virt-manager) or they would use their management interface
>> (either QMP or libvirt).
>>
>> The complexity of interaction is due to the fact that perf shouldn't be a
>> stand alone tool.  It should be a library or something with a programmatic
>> interface that another tool can make use of.
>>      
> But ... a GUI interface/integration is of course possible too, and it's being
> worked on.
>
> perf is mainly a kernel developer tool, and kernel developers generally dont
> use GUIs to do their stuff: which is the (sole) reason why its first ~850
> commits of tools/perf/ were done without a GUI. We go where our developers
> are.
>
> In any case it's not an excuse to have no proper command-line tooling. In fact
> if you cannot get simpler, more atomic command-line tooling right then you'll
> probably doubly suck at doing a GUI as well.
>    

It's about who owns the user interface.

If qemu owns the user interface, than we can satisfy this in a very 
simple way by adding a perf monitor command.  If we have to support 
third party tools, then it significantly complicates things.

Regards,

Anthony Liguori

> 	Ingo
>    

