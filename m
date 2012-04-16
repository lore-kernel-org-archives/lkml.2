Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2DPDmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:42:11 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47659 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2DPDmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:42:09 -0400
Message-ID: <4F8B93B9.2030801@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:36:25 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 07/16] KVM: MMU: introduce for_each_pte_list_spte
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FC19.8080404@linux.vnet.ibm.com> <20120414114422.e3fe6e2abbfdcce61e6f69c8@gmail.com>
In-Reply-To: <20120414114422.e3fe6e2abbfdcce61e6f69c8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041517-0260-0000-0000-000000DF48B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2012 10:44 AM, Takuya Yoshikawa wrote:

> On Fri, 13 Apr 2012 18:12:41 +0800b
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> It is used to walk all the sptes of the specified pte_list, after
>> this, the code of pte_list_walk can be removed
>>
>> And it can restart the walking automatically if the spte is zapped
> 
> Well, I want to ask two questions:
> 
> 	- why do you prefer pte_list_* naming to rmap_*?
> 	  (not a big issue but just curious)


pte_list is a common infrastructure for both parent-list and rmap.

> 	- Are you sure the whole indirection by this patch will
> 	  not introduce any regression?
> 	  (not restricted to get_dirty)
> 


I tested it with kernbench, no regression is found.

It is not a problem since the iter and spte should be in the cache.

