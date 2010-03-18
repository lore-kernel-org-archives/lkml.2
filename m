Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab0CRJYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:24:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:48271 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab0CRJYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:24:43 -0400
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100318085607.GB2157@elte.hu>
Date: Thu, 18 Mar 2010 10:24:37 +0100
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de>
References: <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18.03.2010, at 09:56, Ingo Molnar wrote:

> 
> * Avi Kivity <avi@redhat.com> wrote:
> 
>> On 03/17/2010 10:10 AM, Ingo Molnar wrote:
>>> 
>>>> It's about who owns the user interface.
>>>> 
>>>> If qemu owns the user interface, than we can satisfy this in a very 
>>>> simple way by adding a perf monitor command.  If we have to support third 
>>>> party tools, then it significantly complicates things.
>>> 
>>> Of course illogical modularization complicates things 'significantly'.
>> 
>> Who should own the user interface then?
> 
> If qemu was in tools/kvm/ then we wouldnt have such issues. A single patch (or 
> series of patches) could modify tools/kvm/, arch/x86/kvm/, virt/ and 
> tools/perf/.

It's not a 1:1 connection. There are more users of the KVM interface. To name a few I'm aware of:

- Mac-on-Linux (PPC)
- Dolphin (PPC)
- Xenner (x86)
- Kuli (s390)

Having a clear userspace interface is the only viable solution there. And if you're interested, look at my MOL enabling patch. It's less than 500 lines of code.

The kernel/userspace interface really isn't the difficult part. Getting device emulation working properly, easily and fast is.


Alex