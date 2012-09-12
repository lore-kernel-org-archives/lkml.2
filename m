Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab2ILPei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:34:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab2ILPeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:34:37 -0400
Message-ID: <5050AB89.20705@redhat.com>
Date: Wed, 12 Sep 2012 18:34:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 12/12] KVM: indicate readonly access fault
References: <5032F8FD.2020306@linux.vnet.ibm.com> <5032FA78.9040405@linux.vnet.ibm.com> <5034CB60.30107@redhat.com> <5034D4E3.2080801@linux.vnet.ibm.com> <5048AE96.3050909@redhat.com> <5049C4D7.50101@linux.vnet.ibm.com> <20120910223140.GA24275@amt.cnet> <504F01DE.20505@redhat.com> <20120911143901.GA11792@amt.cnet>
In-Reply-To: <20120911143901.GA11792@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 05:39 PM, Marcelo Tosatti wrote:
> On Tue, Sep 11, 2012 at 12:18:22PM +0300, Avi Kivity wrote:
>> > The same can happen with slot deletion, for example. 
>> > 
>> > Userspace (which performed the modification which can result in faults
>> > to non-existant/read-only/.../new-tag memslot), must handle the faults 
>> > properly or avoid the possibility for reference to memslot information 
>> > from the past.
>> > 
>> > I think its worthwhile to add a note about this in the API
>> > documentation: "The user of this interface is responsible for handling 
>> > references to stale memslot information, either by handling
>> > exit notifications which reference stale memslot information or not
>> > allowing these notifications to exist by stopping all vcpus in userspace
>> > before performing modifications to the memslots map".
>> 
>> Or we can drop the new interface and rely on userspace to perform the
>> lookup under its own locking rules.
>> 
>> It's slow, but writes to ROM or ROM/device are rare anyway.
> 
> Lookup what information? 

Where to dispatch the write.

In fact userspace has to do that anyway if it's a ROM/device.  There's
no way userspace can guess that unless we pass in the slot number (which
isn't synchronized with anything).


-- 
error compiling committee.c: too many arguments to function
