Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2DQG1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:27:14 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46063 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2DQG1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:27:13 -0400
Message-ID: <4F8D0D29.9050009@linux.vnet.ibm.com>
Date: Tue, 17 Apr 2012 14:26:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Avi Kivity <avi@redhat.com>, kvm-ppc@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com>	<20120409175829.GB21894@amt.cnet> <4F8329D3.7000605@gmail.com>	<20120409194614.GB23053@amt.cnet> <4F840DD2.3090101@redhat.com> <20120410204031.ffb5b976225ac9fe6dae474e@gmail.com> <4F842074.1050108@linux.vnet.ibm.com> <20120411211514.35db29c11460516e604059b6@gmail.com> <4F857B61.9080602@linux.vnet.ibm.com> <20120411231441.9d0984672dd252b806f99128@gmail.com> <20120413232528.c5ddbddb3cc0870d6e85a332@gmail.com> <4F8A95CB.9070104@redhat.com> <20120417004935.a9a39d951b3c24588e29edd2@gmail.com>
In-Reply-To: <20120417004935.a9a39d951b3c24588e29edd2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041620-1618-0000-0000-00000152C487
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 11:49 PM, Takuya Yoshikawa wrote:


> Although O(1) is actually O(1) for GET_DIRTY_LOG thread, it adds some
> overheads to page fault handling.  We may need to hold mmu_lock for properly
> handling O(1)'s write protection and ~500 write protections will not be so
> cheap.  And there is no answer to the question how to achive slot-wise write
> protection.
> 


Actually no.

We do not increase the overload on page fault for migration. The number of
page fault of O(1) is the same as write-protect all spte.

And, we can also avoid to hold mmu_lock to write-protect PML4s, we can use
a generation number, and notify mmu to update its page table when dirty-log
is enabled.

Anyway, no performance data, no truth. Let me implement it first.

