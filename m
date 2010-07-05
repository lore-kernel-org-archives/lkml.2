Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0GEJfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:35:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51145 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab0GEJfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:35:41 -0400
Message-ID: <4C31A684.2000109@cn.fujitsu.com>
Date: Mon, 05 Jul 2010 17:31:48 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com> <4C2F2835.5060508@redhat.com> <4C2F2A0C.90704@cn.fujitsu.com> <4C2F2C5B.9020503@redhat.com> <4C2F2DBB.50904@cn.fujitsu.com> <4C2F30BD.7050702@redhat.com> <4C2F31D9.5010104@redhat.com> <4C2F3527.3020307@cn.fujitsu.com> <4C309B23.9060808@redhat.com> <4C3148FF.3030209@cn.fujitsu.com> <4C319699.9000104@redhat.com> <4C319BBB.5020408@cn.fujitsu.com> <4C31A069.6090806@redhat.com> <4C31A13F.9030408@cn.fujitsu.com> <4C31A3F0.6070207@redhat.com>
In-Reply-To: <4C31A3F0.6070207@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

> 
> Note: I think we have to check _after_ kvm_mmu_get_page(), otherwise we
> might be checking a page that is not write-protected and can change again.
> 
> So the logic needs to be something like
> 
> for_each_shadow_entry:
>     if (!last_level && !present(*spte))
>         kvm_mmu_get_page
>     verify gpte
>     if (last_level)
>         mmu_set_spte()
> 

Agree! Will do it.
