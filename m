Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1LWEEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 23:04:15 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60860 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1LWEEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 23:04:13 -0500
Message-ID: <4EF3FDB5.90600@linux.vnet.ibm.com>
Date: Fri, 23 Dec 2011 12:04:05 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/8] KVM: MMU: drop unsync_child_bitmap
References: <4EEB19AF.5070501@linux.vnet.ibm.com> <4EEB1A71.4040503@linux.vnet.ibm.com> <4EEDAB87.1030506@redhat.com>
In-Reply-To: <4EEDAB87.1030506@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11122304-5564-0000-0000-0000009E888F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2011 04:59 PM, Avi Kivity wrote:

> On 12/16/2011 12:16 PM, Xiao Guangrong wrote:
>> unsync_child_bitmap is used to record which spte has unsync page or unsync
>> children, we can set a free bit in the spte instead of it
>>
> 
> unsync_child_bitmap takes one cacheline; the shadow page table takes
> 64.  This will make unsync/resync much more expensive.
> 


Indeed, need more thing about this patch...

> I suggest to put unsync_child_bitmap at the end (together with
> unsync_children) and simply not allocate it when unneeded (have two
> kmem_caches for the two cases).
> 
> 


Good point, thanks Avi.

