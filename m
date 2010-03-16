Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966227Ab0CPNhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966183Ab0CPNhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:37:52 -0400
Message-ID: <4B9F8991.3030700@redhat.com>
Date: Tue, 16 Mar 2010 15:37:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <20100316102052.GC10069@elte.hu> <4B9F603B.4080004@redhat.com> <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9F84C0.70706@redhat.com> <20100316133114.GB575@elte.hu>
In-Reply-To: <20100316133114.GB575@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 03:31 PM, Ingo Molnar wrote:
>
>> You can do that through libvirt, but that only works for guests started
>> through libvirt.  libvirt provides command-line tools to list and manage
>> guests (for example autostarting them on startup), and tools built on top of
>> libvirt can manage guests graphically.
>>
>> Looks like we have a layer inversion here.  Maybe we need a plugin system -
>> libvirt drops a .so into perf that teaches it how to list guests and get
>> their symbols.
>>      
> Is libvirt used to start up all KVM guests? If not, if it's only used on some
> distros while other distros have other solutions then there's apparently no
> good way to get to such information, and the kernel bits of KVM do not provide
> it.
>    

Developers tend to start qemu from the command line, but the majority of 
users and all distros I know of use libvirt.  Some users cobble up their 
own scripts.

> To the user (and to me) this looks like a KVM bug / missing feature. (and the
> user doesnt care where the blame is) If that is true then apparently the
> current KVM design has no technically actionable solution for certain
> categories of features!
>    

A plugin system allows anyone who is interested to provide the 
information; they just need to write a plugin for their management tool.

Since we can't prevent people from writing management tools, I don't see 
what else we can do.

-- 
error compiling committee.c: too many arguments to function

