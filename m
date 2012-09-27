Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2I0Q0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:26:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab2I0Q0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:26:11 -0400
Message-ID: <50647E0B.6080303@redhat.com>
Date: Thu, 27 Sep 2012 18:25:47 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] KVM: MMU: fix release noslot pfn
References: <505C0FA8.5070007@linux.vnet.ibm.com> <505C0FCF.2070308@linux.vnet.ibm.com> <20120923091335.GA20907@redhat.com> <505FE8B4.8030309@linux.vnet.ibm.com> <20120924112416.GA23096@redhat.com> <506048D1.70403@linux.vnet.ibm.com> <20120924120424.GB23096@redhat.com> <506052D1.5000006@linux.vnet.ibm.com>
In-Reply-To: <506052D1.5000006@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 02:32 PM, Xiao Guangrong wrote:

> 3 places after the whole patchset (There are some cleanups after this patch).
> 
>> and one by even stronger is_error_pfn(). 
> 
> This one is:
> 
> |	if (!is_error_pfn(pfn)) {
> |                kvm_release_pfn_clean(pfn);
> |                return true;
> |	}
> |
> |	return false;
> 
> We can change it to:
> 
> | if (is_error_pfn(pfn))
> |	return false;
> |
> | kvm_release_pfn_clean(pfn);
> | return true;
> 
>> I guess when/if other architectures will add MMIO MMU
>> caching they will need to guard kvm_release_pfn_clean() by is_noslot_pfn()
>> too in most cases. I am not insisting, but as this patch shows it is
>> easy to miss the check before calling the function.
> 
> Sounds reasonable. I will consider it if Avi/Marcelo have no object on
> it.

I think it's a good idea.

Looks like we traded the unscalable error pages for these branches, I
think it's a reasonable tradeoff.

-- 
error compiling committee.c: too many arguments to function
