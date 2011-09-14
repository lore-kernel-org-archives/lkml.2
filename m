Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab1INJ7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 05:59:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab1INJ7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 05:59:05 -0400
Message-ID: <4E707AE5.2030704@redhat.com>
Date: Wed, 14 Sep 2011 12:59:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 11/11] KVM: MMU: improve write flooding detected
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4D17.2080700@cn.fujitsu.com> <4E6F395A.5030609@redhat.com> <4E6FACBD.1020801@cn.fujitsu.com>
In-Reply-To: <4E6FACBD.1020801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 10:19 PM, Xiao Guangrong wrote:
> >
> >  The spte may not be accessed, but other sptes in the same page can be accessed.  An example is the fixmap area for kmap_atomic(), there will be a lot of pte writes but other sptes will be accessed without going through soft-mmu at all.
>
> I think this kind of shadow pae is mostly the last page table(level=1), maybe
> we can skip the write-flooding for the last shadow page, because the last shadow
> page can become unsync and it can not let page table write-protected.

Yes.

>
> >  I think you have to read the parent_ptes->spte.accessed bits to be sure.
> >
>
> I guess the overload of this way is little high:
> - it needs to walk parent ptes for every shadow pages
> - we need to clear the parent_ptes->spte.accessed bit when the page is written, and
>    the tlb flush is needed.
> no?
>

Right.

-- 
error compiling committee.c: too many arguments to function

