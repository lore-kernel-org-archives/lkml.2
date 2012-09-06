Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab2IFOLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab2IFOLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:11:18 -0400
Message-ID: <5048AE96.3050909@redhat.com>
Date: Thu, 06 Sep 2012 17:09:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 12/12] KVM: indicate readonly access fault
References: <5032F8FD.2020306@linux.vnet.ibm.com> <5032FA78.9040405@linux.vnet.ibm.com> <5034CB60.30107@redhat.com> <5034D4E3.2080801@linux.vnet.ibm.com>
In-Reply-To: <5034D4E3.2080801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 03:47 PM, Xiao Guangrong wrote:
> On 08/22/2012 08:06 PM, Avi Kivity wrote:
>> On 08/21/2012 06:03 AM, Xiao Guangrong wrote:
>>> Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
>>> caused by write access on readonly memslot
>> 
>> Please document this in chapter 5 of apic.txt.
>> 
> 
> Okay, please review this one.
> 
> Subject: [PATCH v6 12/12] KVM: indicate readonly access fault
> 
> Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
> caused by write access on readonly memslot
> 

I'm not sure whether this indication can be trusted by userspace.  By
the time userspace gets to process this, the slot may no longer exist,
or it may be writable.

(in the same way an mmio exit might actually hit RAM)


-- 
error compiling committee.c: too many arguments to function
