Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2FINR2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 09:17:28 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59037 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab2FINR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 09:17:26 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 02/16] hugetlb: don't use ERR_PTR with VM_FAULT* values
In-Reply-To: <20120609111010.GA16034@localhost.localdomain>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120609111010.GA16034@localhost.localdomain>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 09 Jun 2012 18:47:14 +0530
Message-ID: <87mx4clj51.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12060913-3864-0000-0000-0000034227BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad@darnok.org> writes:

> On Sat, Jun 09, 2012 at 02:29:47PM +0530, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> The current use of VM_FAULT_* codes with ERR_PTR requires us to ensure
>> VM_FAULT_* values will not exceed MAX_ERRNO value. Decouple the
>> VM_FAULT_* values from MAX_ERRNO.
>
> I see you using the -ENOMEM|-ENOSPC, but I don't see any reference in the
> code to MAX_ERRNO? Can you provide a comment explaining in a tad little
> bit about the interaction of MAX_ERRNO and VM_FAULT?

That comes from this 

#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)


-aneesh

